package Panoptic::Schema::PDB::ResultSet::Camera;

use Moose;
use namespace::autoclean;
use Panoptic::Common qw/$config/;

BEGIN {
    extends 'DBIx::Class::ResultSet';
};

# cameras currently being viewed live
sub live {
    my ($self) = @_;

    my $minutes = $config->{camera}{live}{interval}+0
        or die "camera.live.interval is not defined";

    # camera considered being viewed live if updated live in the last $minutes minutes
    my $live_interval = "$minutes MINUTE";

    return $self->search({
        last_live_update => { '>=' => \ "NOW() - INTERVAL '$live_interval'" },
    });
}

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
