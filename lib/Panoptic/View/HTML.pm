package Panoptic::View::HTML;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Panoptic::View::TT' };

__PACKAGE__->config({
    WRAPPER => 'wrapper/html.tt',
});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);


