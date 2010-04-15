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

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
    name => 'Int80',
    disable_component_resolution_regex_fallback => 1,
    root         => Int80->path_to('root'),
    default_view => 'TT',
    
    'View::TT' => {
        INCLUDE_PATH => [
          Int80->path_to( 'root', 'src' ),
          Int80->path_to( 'root', 'lib' ),
        ],
        TEMPLATE_EXTENSION => '.tt2',
        CATALYST_VAR => 'c',
        TIMER        => 0,
        #PRE_PROCESS  => 'config/main',
        WRAPPER      => 'wrapper.tt2',
        render_die   => 1,
    },
);

__PACKAGE__->setup();

1;
