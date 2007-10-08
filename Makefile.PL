use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Net::DHCP::Info',
    AUTHOR              => 'Jan Henning Thorsen <pm@flodhest.net>',
    VERSION_FROM        => 'lib/Net/DHCP/Info.pm',
    ABSTRACT_FROM       => 'lib/Net/DHCP/Info.pm',
    PL_FILES            => {},
    PREREQ_PM           => {
                               'DateTime'    => 0,
                               'NetAddr::IP' => 0,
                           },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Net-DHCP-Info-*' },
);
