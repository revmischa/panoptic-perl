package Int80::Util;

use Moose;
use Config::JFDI;
use namespace::autoclean;

sub get_config {
    my $config = Config::JFDI->new(name => "Int80");
    my $config_hash = $config->get;
    
    return $config_hash;
}

1;
