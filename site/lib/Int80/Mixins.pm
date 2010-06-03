package Int80;

use strict;
use warnings;

use JSON::XS ();

# pass variables from configuration to javascript
sub jsconfig {
    my ($c) = @_;
    
    my $conf = $c->config->{js};

    my $encoder = JSON::XS->new->ascii->allow_nonref;
    return "var global_config = " . $encoder->encode($conf) . ';';
}

1;