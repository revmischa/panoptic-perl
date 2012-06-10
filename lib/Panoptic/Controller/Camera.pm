package Panoptic::Controller::Camera;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Rapid::Controller::SimpleCRUD' }

__PACKAGE__->config({
    model_class => 'PDB::Camera',
    item_label => 'Camera',
    add_form => 'Panoptic::Form::Camera::Create',
    templates => {
        create => 'camera/create.tt',
        list => 'camera/list.tt',
    },
});

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->forward('list');
}

sub base :Chained('/') :PathPart('camera') :CaptureArgs(0) {}

__PACKAGE__->meta->make_immutable;

