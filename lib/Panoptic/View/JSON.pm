package Panoptic::View::JSON;

use Moose;
BEGIN { extends 'Catalyst::View::JSON'; };

# only expose stash keys that start with 'res_'
__PACKAGE__->config(
    expose_stash => qr/^res\_/,
);

after 'process' => sub {
    my ($self, $c) = @_;

    # fix issue with dumb browsers and file upload iframe hack
    $c->res->content_type('text/html') unless $c->stash->{force_json_content_type};
};

1;
