package Int80::View::TT;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::View::TT'; }

no Moose;
__PACKAGE__->meta->make_immutable;
