package Panoptic::Form::Camera::Create;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+item_class' => ( default => 'Camera' );

has 'name' => ();

__PACKAGE__->meta->make_immutable;
