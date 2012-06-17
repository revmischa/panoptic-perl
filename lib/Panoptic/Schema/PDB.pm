use utf8;
package Panoptic::Schema::PDB;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-06-17 01:56:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VV5E3BowiWDTuvevtLQKBA

__PACKAGE__->load_namespaces(
    result_namespace => '+Rapid::Schema::RDB::Result',
    resultset_namespace => '+Rapid::Schema::RDB::ResultSet',
);

1;


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
