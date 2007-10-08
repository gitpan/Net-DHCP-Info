#!perl

use warnings;
use strict;
use Net::DHCP::Info;
use Test::More tests => 3;


my $config = Net::DHCP::Info->new("./t/dhcpd.conf");

is(ref $config, "Net::DHCP::Info", "obj constructed");

my $net = $config->fetch_subnet;

is($net->addr, "192.168.0.0", "ip is ok");
is($net->routers->[0], "192.168.0.1", "routers is ok");

