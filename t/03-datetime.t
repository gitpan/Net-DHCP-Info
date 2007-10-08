#!perl

use warnings;
use strict;
use Net::DHCP::Info;
use Test::More tests => 3;


my $config = Net::DHCP::Info->new("./t/dhcpd.leases");

is(ref $config, "Net::DHCP::Info", "obj constructed");

my $lease = $config->fetch_lease;

is($lease->starts, "2007/09/19 17:51:41", "starts is ok");
is(ref $lease->starts_datetime, "DateTime", "datetime is ok");

