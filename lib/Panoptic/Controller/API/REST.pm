package Panoptic::Controller::API::REST;

use Moose;
BEGIN { extends 'Catalyst::Controller::DBIC::API::REST'; }

# don't use HashRefInflator, always instantiate DBIC objects
# might want to define this per-API, but probably not
has '+result_class' => ( default => '' );

# augment this to return a hashref with extra params
sub row_format_output {
    my ($self, $c, $row) = @_;

    my $ret = { $row->get_columns };

    my $extra = inner($c, $row, $ret);
    if ($extra) {
        $ret->{$_} = $extra->{$_} for keys %$extra;
    }

    # keep track of our output
    $c->stash->{_restapi_current_rows} ||= [];
    push @{ $c->stash->{_restapi_current_rows} }, $row;

    return $ret;
}

sub rows {
    my ($self, $c) = @_;
    my $rows = $c->stash->{_restapi_current_rows} or return;
    return @$rows;
}

sub list_one_object {}

sub rest_base :Chained('/api/api_base') PathPart('rest') CaptureArgs(0) {}

no Moose;
__PACKAGE__->meta->make_immutable;
