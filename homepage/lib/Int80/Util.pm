package Int80::Util;

use strict;
use warnings;

use Config::JFDI;

sub get_config {
    my $config = Config::JFDI->new(name => "Int80");
    my $config_hash = $config->get;
    
    return $config_hash;
}
1;
