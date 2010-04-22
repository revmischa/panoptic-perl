package Int80::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config(
    stash_key => 'email'
);

=head1 NAME

Int80::View::Email - Email View for Int80

=head1 DESCRIPTION

View for sending email from Int80. 

=head1 AUTHOR

aesop,,,

=head1 SEE ALSO

L<Int80>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
