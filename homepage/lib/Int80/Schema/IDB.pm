package Int80::Schema::IDB;

use Moose;
BEGIN { extends 'DBIx::Class::Schema' }

use Int80::Util;

__PACKAGE__->load_namespaces(
	result_namespace => 'Result',
);

sub get_connection {
	my ($class) = @_;
	
	my $config = Int80::Util->get_config;

    my $connect_info = $config->{'Model::IDB'}->{connect_info}
        or die "Could not find Model::IDB config";

	my $schema = __PACKAGE__->connect(@$connect_info);
	return $schema;
}

no Moose;
__PACKAGE__->meta->make_immutable;

