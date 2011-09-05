# This represents an AV stream

package Panoptic::Stream;

use Moose;
use Rapit::UUID;
use namespace::autoclean;

has 'id' => (
    is => 'rw',
    isa => 'Integer',
    lazy_build => 1,
);

sub _build_id { Rapit::UUID->create }

__PACKAGE__->meta->make_immutable;
