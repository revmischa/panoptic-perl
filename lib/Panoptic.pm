package Panoptic;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Panoptic::Container;

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Bread::Board
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'Panoptic',
    disable_component_resolution_regex_fallback => 1,
    'Plugin::Bread::Board' => {
        container => Panoptic::Container->new(
            app_root => __PACKAGE__->path_to('.'),
        ),
    },
);

__PACKAGE__->setup;

1;
