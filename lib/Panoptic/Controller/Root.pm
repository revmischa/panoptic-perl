package Panoptic::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dump;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

# this goes to index.tt, which goes to /camera/list.
# jqmobile gets confused if it ends up going to /camera/list if the page it 
# initally loaded was /camera/list. even though they have the same ids and data-urls.
sub index :Path :Args(0) {}

sub default :Path {
    my ($self, $c) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

sub access_denied :Private {
    my ($self, $c) = @_;
    $c->forward('/user/login');
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

