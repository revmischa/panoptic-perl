package Int80::Model::IDB;

use Moose;
BEGIN { extends 'Catalyst::Model::DBIC::Schema' }

__PACKAGE__->config(
    schema_class => 'Int80::Schema::IDB',
);

no Moose;
__PACKAGE__->meta->make_immutable;

