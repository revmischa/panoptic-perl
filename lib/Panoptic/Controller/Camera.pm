package Panoptic::Controller::Camera;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->forward('list');
}

sub list :Local {
    my ($self, $c) = @_;

    my $cameras = $c->model('PDB::Camera')->search({});

    $c->stash(
        cameras => $cameras,
        template => 'camera/list.tt',
    );
}

__PACKAGE__->meta->make_immutable;

