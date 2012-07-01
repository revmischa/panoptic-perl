package Panoptic::Controller::API::REST::Camera;

use Moose;
BEGIN { extends 'Panoptic::Controller::API::REST'; }

__PACKAGE__->config({
    action => {
        setup => {
            PathPart => 'camera',
            Chained => '/api/rest/rest_base',
        },
    },

    select => [qw/ id title snapshot_s3_key snapshot_last_updated thumbnail_last_updated /],
    ordered_by => [qw/ title /],
    class => 'PDB::Camera',
    create_required => [qw/ title /],
    create_allows => [qw/ title /],
});

after end => sub {
    my ($self, $c) = @_;

    if ($c->req->param('updateLive')) {
        # mark each camera as being viewed live
        my @rows = $self->rows($c);
        $_->update({ 'last_live_update' => \ 'NOW()' }) for @rows;
    }
};

augment 'row_format_output' => sub {
    my ($self, $c, $row) = @_;

    my $ret = {};

    # add snapshot uri
    my $snapshot_uri = $row->s3_snapshot_uri;
    $ret->{s3_snapshot_uri} = $snapshot_uri;

    # last updated time
    my $snapshot_last_updated = $row->snapshot_last_updated;
    $ret->{snapshot_last_updated} = $snapshot_last_updated ? $snapshot_last_updated->epoch : undef;

    return $ret;
};

no Moose;
__PACKAGE__->meta->make_immutable;
