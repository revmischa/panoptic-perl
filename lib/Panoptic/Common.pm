package Panoptic::Common;

use Moose;
use namespace::autoclean;

$Rapid::APP_NAME = 'panoptic';
extends 'Rapid';

__PACKAGE__->meta->make_immutable;
