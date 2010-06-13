package Int80;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use CatalystX::RoleApplicator;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple

    Session
    Session::State::Cookie
    Session::Store::DBIC
    Authentication
    
    ErrorCatcher
    StackTrace
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

__PACKAGE__->apply_request_class_roles(qw[
    Catalyst::TraitFor::Request::REST::ForBrowsers
]);

1;
