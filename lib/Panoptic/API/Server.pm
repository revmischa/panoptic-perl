# Panoptic Server
# Mischa S.
# Sept. 2011

# Panoptic clients connect to this server and register themselves,
# synchronize configs, and respond to stream initiation requests

package Panoptic::API::Server;

use Moose;
use AnyEvent;
use namespace::autoclean;

extends 'Rapid::API::Server::Async';
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
        'stream' => \&stream_handler,
    );
};

# tell client to start streaming at us
# probably only called from console interface
sub stream_handler {
    my ($self, $msg) = @_;

    my $uri = $msg->params->{uri};
    unless ($uri) {
        warn "uri parameter missing\n";
        return;
    }

    $self->broadcast(message('initiate_stream', $msg->params));
}

# push out server configs to client, request clients to send their configs, sync
sub server_sync_all {
    my ($self) = @_;

    $self->push_sync_all;
    $self->request_sync_all;
}

__PACKAGE__->meta->make_immutable;
