package Panoptic::Schema::PDB;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2012-06-11 18:37:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lpOViLi/T5kwcZB3ROIR2Q

__PACKAGE__->load_namespaces(
    result_namespace => '+Rapid::Schema::RDB::Result',
    resultset_namespace => '+Rapid::Schema::RDB::ResultSet',
);

1;
