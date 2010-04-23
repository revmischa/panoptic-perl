package Int80::View::Email::Template;

use Moose;
BEGIN { extends 'Catalyst::View::Email::Template'; }

__PACKAGE__->config(
    stash_key       => 'email',
    template_prefix => ''
);

no Moose;
__PACKAGE__->meta->make_immutable;
