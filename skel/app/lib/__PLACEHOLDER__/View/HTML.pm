package __PLACEHOLDER__::View::HTML;

use Moose;
use namespace::autoclean;

BEGIN { extends '__PLACEHOLDER__::View::TT'; }

__PACKAGE__->config(
    WRAPPER => 'wrapper.tt2',
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
