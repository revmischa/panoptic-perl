package Panoptic::Script::RegenerateSchema;

use Moose;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use Rapid::Config;
use FindBin;

with 'Panoptic::Script';

my $tables_to_dump = qr/
    (camera)|(camera_model)
/x;

sub run {
    my ($self) = @_;

    my $c = $self->container;
    my $connection_info = $c->config_instance->db_connect_info;

    make_schema_at(
        'Panoptic::Schema::PDB', {
            constraint => $tables_to_dump,
            use_namespaces => 1,
            use_moose => 1,
            naming => 'current',
            generate_pod => 0,
            #additional_classes => [ 'DBIx::Class::MooseColumns' ],
            dump_directory => "$FindBin::Bin/../lib/",
            components => [qw/ InflateColumn::DateTime /],
        },
        $connection_info,
    );
}

1;
