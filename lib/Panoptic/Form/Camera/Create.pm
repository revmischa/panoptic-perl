package Panoptic::Form::Camera::Create;

use HTML::FormHandler::Moose;
extends 'Panoptic::Form';

has '+item_class' => ( default => 'Camera' );

has_field 'name' => (
    type => 'Text',
    required => 1,
    placeholder => 'Name',
);

__PACKAGE__->meta->make_immutable;
