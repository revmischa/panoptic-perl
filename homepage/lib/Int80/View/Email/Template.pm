package Int80::View::Email::Template;

use strict;
use base 'Catalyst::View::Email::Template';

__PACKAGE__->config(
    stash_key       => 'email',
    template_prefix => ''
);

=head1 NAME

Int80::View::Email::Template - Templated Email View for Int80

=head1 DESCRIPTION

View for sending template-generated email from Int80. 

=head1 AUTHOR

aesop,,,

=head1 SEE ALSO

L<Int80>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
