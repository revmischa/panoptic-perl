# This represents an AV stream

package Panoptic::Stream;

use Moose;
use Rapid::UUID;
use namespace::autoclean;

has 'id' => (
    is => 'rw',
    isa => 'Integer',
    lazy_build => 1,
);

sub _build_id { Rapid::UUID->create }

__PACKAGE__->meta->make_immutable;
