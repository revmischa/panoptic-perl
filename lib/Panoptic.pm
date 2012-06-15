package Panoptic;

use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.80;

use Catalyst qw/
    ConfigLoader
    Static::Simple
    
    Authentication
    Authorization::ACL
    Authentication::Credential::Password

    Session
    Session::State::Cookie
    Session::State::URI
    Session::Store::DBIC   
    
    StackTrace
    ErrorCatcher
    LogWarnings
/;

extends 'Catalyst';
with 'CatalystX::REPL';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'Panoptic',
);

__PACKAGE__->setup;


### ACLs
__PACKAGE__->deny_access_unless("/camera"  => \&check_logged_in);

sub check_logged_in      { shift->user_exists }
sub check_customer_realm { shift->user_in_realm('model') }
sub check_admin_realm    { shift->user_in_realm('admin') }

1;
