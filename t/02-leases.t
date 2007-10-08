#!perl

use warnings;
use strict;
use Net::DHCP::Info;
use Test::More tests => 3;


my $config = Net::DHCP::Info->new("./t/dhcpd.leases");

is(ref $config, "Net::DHCP::Info", "obj constructed");

my $lease = $config->fetch_lease;

is($lease->addr, "192.168.0.253", "ip is ok");
is($lease->mac, "000e7bccbbaa", "mac is ok");

