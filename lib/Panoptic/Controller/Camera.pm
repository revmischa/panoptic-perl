package Panoptic::Controller::Camera;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Rapid::Controller::SimpleCRUD' }

__PACKAGE__->config({
    model_class => 'PDB::Camera',
    item_label => 'camera',
    add_form => 'Panoptic::Form::Camera::Create',
    templates => {
        create => 'camera/create.tt',
        list => 'camera/list.tt',
    },
});

sub index :Path Args(0) {
    my ($self, $c) = @_;

    $c->forward('list');
}

sub base :Chained('/') PathPart('camera') CaptureArgs(0) {}

sub list_inner :Local {
    my ($self, $c) = @_;
    $c->forward('list'); # load cameras in stash
    $c->stash(
        template => 'camera/list_inner.tt',
        current_view => 'TT',
    );
}

after 'create' => sub {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' && $c->stash->{form}->validated) {
        $c->forward('list');
    }
};


sub live :Chained('item') PathPart('live') {

}

__PACKAGE__->meta->make_immutable;

