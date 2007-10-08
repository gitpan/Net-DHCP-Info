
#=======================
package Net::DHCP::Info;
#=======================

use strict;
use warnings;
use Net::DHCP::Info::Obj;

our $VERSION     = '0.01';
our $FIND_NET    = qr{^([^s]*)subnet\s+([\d\.]+)\s+netmask\s+([\d\.]+)};
our $ROUTERS     = qr{^\s*option\s+routers\s+([\d\.\s]+)};
our $RANGE       = qr{^\s*range\s+([\d\.]+)\s*([\d\.]*)};
our $FIND_LEASE  = qr{^lease\s([\d\.]+)};
our $STARTS      = qr{^\s+starts\s\d+\s(.+)};
our $ENDS        = qr{^\s+ends\s\d+\s(.+)};
our $HW_ETHERNET = qr{^\s+hardware\sethernet\s(.+)};
our $REMOTE_ID   = qr{option\sagent.remote-id\s(.+)};
our $CIRCUIT_ID  = qr{option\sagent.circuit-id\s(.+)};
our $BINDING     = qr{^\s+binding\sstate\s(.+)};
our $END         = qr{^\}$};


sub fetch_subnet { #==========================================================

    ### init
    my $self = shift;
    my $tab  = "";
    my $net;

    FIND_NET:
    while(readline $self) {
        if(my($tab, @ip) = /$FIND_NET/mx) {
            $net = Net::DHCP::Info::Obj->new(@ip);
            last FIND_NET;
        }
    }

    READ_NET:
    while(readline $self) {

        s/\;//mx;

        if(/$ROUTERS/mx) {
            $net->routers([ split /\s+/mx, $1 ]);
        }
        elsif(my @net = /$RANGE/mx) {
            $net[1] = $net[0] unless($net[1]);
            $net->_add_range(\@net);
        }
        elsif(/$tab\}/mx) {
            last READ_NET;
        }
    }

    ### the end
    return ref $net ? $net : undef;
}

sub fetch_lease { #===========================================================

    ### init
    my $self = shift;
    my $lease;

    FIND_LEASE:
    while(readline $self) {
        if(my($ip) = /$FIND_LEASE/mx) {
            $lease = Net::DHCP::Info::Obj->new($ip);
            last FIND_LEASE;
        }
    }

    READ_LEASE:
    while(readline $self) {

        s/\;//mx;

        if(/$STARTS/mx) {
            $lease->starts($1);
        }
        elsif(/$ENDS/mx) {
            $lease->ends($1);
        }
        elsif(/$HW_ETHERNET/mx) {
            $lease->mac( fixmac($1) );
        }
        elsif(/$REMOTE_ID/mx) {
            $lease->remote_id( fixmac($1) );
        }
        elsif(/$CIRCUIT_ID/mx) {
            $lease->circuit_id( fixmac($1) );
        }
        elsif(/$BINDING/mx) {
            $lease->binding($1);
        }
        elsif(/$END/mx) {
            last READ_LEASE;
        }
    }

    ### the end
    return ref $lease ? $lease : undef;
}

sub new { #===================================================================

    ### init
    my $class = shift;
    my $file  = shift;

    ### detect error
    return 'file does not exist'  unless(-f $file);
    return 'file is not readable' unless(-r $file);

    ### open file
    open(my $self, '<', $file) or return $!;

    ### the end
    return bless $self, $class;
}

sub fixmac { #================================================================

    ### init
    my $mac = shift;

    ### fix mac
    $mac =  unpack('H*', $mac) if($mac =~ /[\x00-\x1f]/mx);
    $mac =~ y/a-fA-F0-9\://cd;
    $mac =  join "", map {
                             my $i = 2 - length($_);
                             ($i < 0) ? $_ : ("0" x $i) .$_;
                         } split /:/mx, $mac;

    ### the end
    return $mac;
}

#=============================================================================
1983;
__END__

=head1 NAME

Net::DHCP::Info - Fast dhcpd.leases and dhcpd.conf parser

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Net::DHCP::Info;

    my $conf  = Net::DHCP::Info->new($path_to_dhcpd_conf);
    my $lease = Net::DHCP::Info->new($path_to_dhcpd_leases);

    while(my $net = $conf->fetch_subnet) {
        # .. do stuff with $net
    }

    while(my $lease = $lease->fetch_lease) {
        # .. do stuff with $lease
    }

=head1 METHODS

=head2 C<new>

Object constructor. Takes one argument; a filename to parse. This can be
either a dhcpd.conf or dhcpd.leases file.

=head2 C<fetch_subnet>

This method returns an object of the C<Net::DHCP::Info::Obj> class.

=head2 C<fetch_lease>

This method returns an object of the C<Net::DHCP::Info::Obj> class.

=head1 FUNCTIONS

=head2 fixmac

Takes a mac in various formats as an argument, and returns it as a 12 char
string.

=head1 AUTHOR

Jan Henning Thorsen, C<< <pm at flodhest.net> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-net-dhcp-info at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-DHCP-Info>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::DHCP::Info

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-DHCP-Info>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-DHCP-Info>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-DHCP-Info>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-DHCP-Info>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Jan Henning Thorsen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
