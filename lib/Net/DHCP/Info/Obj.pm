
#============================
package Net::DHCP::Info::Obj;
#============================

use strict;
use warnings;
use DateTime;
use NetAddr::IP;

our @ISA     = qw/NetAddr::IP/;
our $VERSION = '0.01';
our $AUTOLOAD;


BEGIN { ## no critic # for strict
    no strict 'refs';
    my %sub2key = qw/
                      routers     __routers
                      starts      __starts
                      ends        __ends
                      mac         __mac
                      remote_id   __remote_id
                      circuit_id  __circuit_id
                      binding     __binding
                      range       __range
                  /;
    for my $subname (keys %sub2key) {
        *$subname = sub {
            my($self, $set)               = @_;
            $self->{ $sub2key{$subname} } = $set if(defined $set);
            $self->{ $sub2key{$subname} };
        }
    }
}

sub _add_range { #============================================================

    ### init
    my $self  = shift;
    my $range = shift;

    return unless(ref $range eq 'ARRAY');

    ### the end
    push @{ $self->{'__range'} }, $range;
    return;
}

sub starts_datetime { #=======================================================
    my $self = shift;
    return $self->_datetime($self->starts);
}

sub ends_datetime { #=========================================================
    my $self = shift;
    return $self->_datetime($self->ends);
}

sub _datetime { #=============================================================

    ### init
    my $self = shift;
    my @time = split m"[\s\:/]"mx, shift;

    return DateTime->new(
        year      => $time[0],
        month     => $time[1],
        day       => $time[2],
        hour      => $time[3],
        minute    => $time[4],
        second    => $time[5],
        time_zone => 'UTC',
    );
}

#=============================================================================
1983;
__END__

=head1 NAME

Net::DHCP::Info::Obj - Storage module for dhcp-information

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

This module contains methods that can access the data C<Net::DHCP::Info>
has extracted. It inherits from C<NetAddr::IP>, so it provides all the methods
from that package as well.

=head1 SYNOPSIS

    use Net::DHCP::Info::Obj;

    my $ip  = "127.0.0.1";
    my $obj = Net::DHCP::Info::Obj->new($ip);

    $obj->mac("aa:b:02:3d:0:01");

    print $obj->mac; # prints the above mac

=head1 METHODS

=head2 starts / starts_datetime

Returns the dhcp leases start time as string / DateTime object.

=head2 ends / ends_datetime

Returns the dhcp leases end time as string / DateTime object.

=head2 mac

Returns the dhcp leases mac.

=head2 remote_id

Returns the dhcp leases remote id.

=head2 circuit_id

Returns the dhcp leases circuit id.

=head2 binding

Returns the dhcp leases binding.

=head2 routers

Returns a list of routers in a subnet.

=head2 range

Returns a list of ranges in a subnet in this format:

[$low_ip, $high_ip]
 
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
