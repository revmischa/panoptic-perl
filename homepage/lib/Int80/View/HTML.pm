package Int80::View::HTML;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Int80::View::TT'; }

__PACKAGE__->config(
    WRAPPER      => 'wrapper.tt2',
);

no Moose;
__PACKAGE__->meta->make_immutable;
