# Panoptic Server
# Mischa S.
# Sept. 2011

# Panoptic clients connect to this server and register themselves,
# synchronize configs, and respond to stream initiation requests

package Panoptic::API::Server;

use Moose;
use AnyEvent;
use Panoptic::Common qw/$schema/;
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

        'update_snapshots' => \&update_snapshots_handler,
        'snapshot_updated' => \&snapshot_updated_handler,
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

sub update_snapshots_handler {
    my ($self, $msg) = @_;

    my $cameras = $schema->resultset('Camera')->search({});
    while (my $camera = $cameras->next) {
        $self->broadcast(message(update_snapshot => {
            camera_id => $camera->id,
            snapshot_uri => $camera->local_snapshot_uri,
        }));
    }

    $self->log->info("Updating snapshots");
}

sub snapshot_updated_handler {
    my ($self, $msg) = @_;

    my $params = $msg->params;
    my $camera_id = $params->{camera_id}
        or return $self->push_error("camera_id missing");
    my $image = $params->{image}
        or return $self->push_error("image missing");
    my $content_type = $params->{content_type};

    warn "got image $content_type for camera $camera_id";
    my $camera = $schema->resultset('Camera')->find($camera_id)
        or return $self->push_error("camera:$camera_id not valid");

    $camera->set_snapshot($image, { content_type => $content_type });
}

# push out server configs to client, request clients to send their configs, sync
sub server_sync_all {
    my ($self) = @_;

    $self->push_sync_all;
    $self->request_sync_all;
    $self->request_sync_all;
}

__PACKAGE__->meta->make_immutable;
