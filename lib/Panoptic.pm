package Panoptic;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Panoptic::Container;

use Catalyst qw/
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'Panoptic',
);

__PACKAGE__->setup;

1;
