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

    select => [qw/ id title snapshot_s3_key /],
    ordered_by => [qw/ title /],
    class => 'PDB::Camera',
    create_required => [qw/ title /],
    create_allows => [qw/ title /],
});

augment 'row_format_output' => sub {
    my ($self, $c, $row) = @_;

    my $ret = {};

    # add snapshot uri
    my $snapshot_uri = $row->s3_snapshot_uri;
    $ret->{snapshot_uri} = $snapshot_uri;
    
    return $ret;
};

no Moose;
__PACKAGE__->meta->make_immutable;
