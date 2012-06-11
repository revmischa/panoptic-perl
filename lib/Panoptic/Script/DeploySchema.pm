package Panoptic::Script::DeploySchema;

use Moose;
with 'Panoptic::Script';

sub run {
    my ($self) = @_;
    
    my $ok = shift @ARGV;
    
    die "run this with YES as the first argument to actually delete the whole freakin' database ok\n"
        unless $ok && $ok eq 'YES';

    my $c = $self->container;
    
    my $schema = $c->schema;
    $schema->deploy({
        add_drop_table => 1,
        quote_identifiers => 1,
#        debug => 1,
    });
}

1;
