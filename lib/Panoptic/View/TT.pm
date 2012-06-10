package Panoptic::View::TT;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::View::TT' };

__PACKAGE__->config({
    INCLUDE_PATH => [
        Panoptic->path_to('root', 'template'),
    ],
#    ENCODING     => 'utf8' ,
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);


