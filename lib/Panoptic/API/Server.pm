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
        'stream_initiated' => \&stream_initiated_handler,
        'stream_terminated' => \&stream_terminated_handler,
    );
};

# client started streaming at us
sub stream_initiated_handler {
    my ($self, $msg) = @_;

    $self->log->info("Client started stream id=" . $msg->params->{stream_id});
}

# client finished streaming
sub stream_terminated_handler {
    my ($self, $msg) = @_;

    $self->log->info("Client terminated stream id=" . $msg->params->{stream_id});
}

# tell client to start streaming at us
# probably only called from console interface
sub stream_handler {
    my ($self, $msg) = @_;

    my $input_uri  = $msg->params->{input_uri}
        or return $self->log->error("Input URI missing");
    my $output_uri = $msg->params->{output_uri}
        or return $self->log->error("Input URI missing");

    $self->broadcast(message('initiate_stream', $msg->params));
}

# push out server configs to client, request clients to send their configs, sync
sub server_sync_all {
    my ($self) = @_;

    $self->push_sync_all;
    $self->request_sync_all;
    $self->request_sync_all;
}

__PACKAGE__->meta->make_immutable;
