package Panoptic::Form::Camera::Edit;

use HTML::FormHandler::Moose;
extends 'Panoptic::Form';
with 'HTML::FormHandler::TraitFor::Model::DBIC';

has '+item_class' => ( default => 'Camera' );

has_field 'title' => (
    type => 'Text',
    required => 1,
    placeholder => 'Name',
);

has_field 'model' => (
    type => 'Select',
    empty_select => 'Choose camera model...',
    label_column => 'name',
);

has_field 'host' => (
    type => 'Select',
    label_column => 'hostname',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
