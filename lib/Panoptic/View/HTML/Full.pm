package Panoptic::View::HTML::Full;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Panoptic::View::HTML' };

__PACKAGE__->config({
    WRAPPER => [ 'wrapper/html.tt', 'wrapper/full.tt' ],
});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);


