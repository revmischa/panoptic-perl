package Int80::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub stylesheet :Path('global.css') {
    my ($self, $c) = @_;
    
    $c->stash(
        current_view => 'TT',
        template => 'global.css.tt2',
    );
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

