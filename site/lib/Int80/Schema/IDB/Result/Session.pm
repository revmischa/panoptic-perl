package Int80::Schema::IDB::Result::Session;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("session");
__PACKAGE__->add_columns(
  "id",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 72 },
  "session_data",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "expires",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
);
__PACKAGE__->set_primary_key("id");

1;
