package Panoptic::Model::PDB;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Model::DBIC::Schema'; }

__PACKAGE__->config({
    schema_class => 'Panoptic::Schema::PDB',
});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
