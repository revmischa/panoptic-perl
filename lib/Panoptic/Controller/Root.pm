package Panoptic::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dump;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->forward('/camera/list');
}

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

