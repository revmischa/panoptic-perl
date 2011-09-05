# Panoptic Server
# Mischa S.
# Sept. 2011

# Panoptic clients connect to this server and register themselves,
# synchronize configs, and respond to stream initiation requests

package Panoptic::API::Server;

use Moose;
use AnyEvent;
use namespace::autoclean;

extends 'Rapit::API::Server::Async';
with 'Panoptic::API';

has 'sync_timer' => (
    is => 'rw',
);

before 'run' => sub {
    my ($self) = @_;

    # periodically synchronize configurations
    my $t = AnyEvent->timer(
        after => 0,
        interval => 2,
        cb => sub { $self->server_sync_all },
    );
    $self->sync_timer($t);
    
    $self->register_callbacks(

    );
};

# push out server configs to client, request clients to send their configs, sync
sub server_sync_all {
    my ($self) = @_;

    $self->push_sync_all;
    $self->request_sync_all;
}

__PACKAGE__->meta->make_immutable;
