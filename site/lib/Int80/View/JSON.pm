package Int80::View::JSON;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::View::JSON'; }

__PACKAGE__->config(
    expose_stash => [qw/json/],
);

use JSON::XS ();

sub encode_json {
    my($self, $c, $data) = @_;
    my $encoder = JSON::XS->new->ascii->pretty->allow_nonref;
    $encoder->encode($data);
}


__PACKAGE__->meta->make_immutable(inline_constructor => 0);

