package Int80::View::Email::Template;

use Moose;
BEGIN { extends ('Catalyst::View::Email::Template', 'Int80::View::HTML'); }

__PACKAGE__->config(
    stash_key => 'email',
);

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
