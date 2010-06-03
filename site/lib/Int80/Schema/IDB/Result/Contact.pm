package Int80::Schema::IDB::Result::Contact;

use base DBIx::Class;
use Moose;

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("contact");
__PACKAGE__->add_columns(
	"id" => { data_type => "INT", is_nullable => 0, is_auto_increment => 1 },
	"name" => { data_type => 'VARCHAR', size => 256, is_nullable => 1 },
	"request" => { data_type => 'TEXT', is_nullable => 1 },
	"email" => { data_type => 'TEXT', is_nullable => 1 },
	"phone" => { data_type => 'TEXT', is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


1;
