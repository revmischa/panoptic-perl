package Panoptic::Controller::Camera;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Rapid::Controller::SimpleCRUD' }

__PACKAGE__->config({
    model_class => 'PDB::Camera',
    item_label => 'camera',
    edit_form => 'Panoptic::Form::Camera::Edit',
    order_by => 'title',
    templates => {
        create => 'camera/create.tt',
        edit   => 'camera/edit.tt',
        list   => 'camera/list.tt',
    },
});

sub index :Path Args(0) {
    my ($self, $c) = @_;

    $c->forward('list');
}

sub base :Chained('/') PathPart('camera') CaptureArgs(0) {}

# API method to render the camera rows
sub list_inner :Local {
    my ($self, $c) = @_;

    $c->forward('list'); # load cameras in stash

    my $list;
    if ($c->user_exists) {
        # render list
        $c->stash(template => 'camera/list_inner.tt');
        $list = $c->view('TT')->render($c, 'camera/list_inner.tt');
    }

    $c->stash(
        res_list => $list,
        current_view => 'JSON',
    );
}

after 'create' => sub {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' && $c->stash->{form}->validated) {
        $c->forward('list');
    }
};

after 'edit' => sub {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' && $c->stash->{form}->validated) {
        $c->forward('list');
    }
};

sub live :Chained('item') PathPart('live') {

}

__PACKAGE__->meta->make_immutable;

