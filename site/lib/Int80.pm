package Int80;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';
use Int80::Mixins;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
    name => 'Int80',
    disable_component_resolution_regex_fallback => 1,
);

# Start the application
__PACKAGE__->setup();

1;
