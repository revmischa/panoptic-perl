package __PLACEHOLDER__;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
    name => '__PLACEHOLDER__',
    disable_component_resolution_regex_fallback => 1,
);

# Start the application
__PACKAGE__->setup();

1;
