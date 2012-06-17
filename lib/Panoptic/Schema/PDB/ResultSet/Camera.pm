package Panoptic::Schema::PDB::ResultSet::Camera;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'DBIx::Class::ResultSet';
};

# camera considered being viewed live if updated live in the last ten minutes
our $LIVE_INTERVAL = '10 MINUTE';

# cameras currently being viewed live
sub live {
    my ($self) = @_;

    return $self->search({
        last_live_update => { '>=' => \ "NOW() - INTERVAL '$LIVE_INTERVAL'" },
    });
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
