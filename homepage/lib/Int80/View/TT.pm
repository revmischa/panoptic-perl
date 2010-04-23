package Int80::View::TT;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::View::TT'; }

__PACKAGE__->config(
    INCLUDE_PATH => [
        Int80->path_to(qw/root src/),
    ],
    TEMPLATE_EXTENSION => '.tt2',
    CATALYST_VAR => 'c',
    render_die => 1,
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
