# Panoptic Server
# Mischa S.
# Sept. 2011

# Panoptic clients connect to this server and register themselves,
# synchronize configs, and respond to stream initiation requests

package Panoptic::API::Server;

use Moose;
use AnyEvent;
use Panoptic::Common qw/$schema $config/;
use namespace::autoclean;
use Carp qw/croak/;

extends 'Rapid::API::Server::Async';
with 'Panoptic::API';

has 'sync_timer' => ( is => 'rw' );
has 'snapshot_refresh_timer' => ( is => 'rw' );

has 'timers' => (
    is => 'ro',
    isa => 'HashRef',
    traits => [ 'Hash' ],
    handles => {
        'save_timer' => 'set',
    },
);

before 'run' => sub {
    my ($self) = @_;

    my $snapshot_refresh_rate = $config->{camera}{snapshot}{refresh_rate}
        or die "camera.snapshot.refresh_rate is not defined in config";
    my $thumbnail_refresh_rate = $config->{camera}{snapshot}{thumbnail_refresh_rate}
        or die "camera.snapshot.thubmanil_refresh_rate is not defined in config";

    # periodically synchronize configurations
    $self->set_timer('sync', 60, sub { $self->server_sync_all });

    # snapshot refresh
    $self->set_timer('snapshot_refresh', $snapshot_refresh_rate, sub { $self->update_snapshots_handler });

    # thumbnail refresh
    $self->set_timer('thumbnail_refresh', $thumbnail_refresh_rate, sub { $self->update_thumbnails_handler });

    $self->register_callbacks(
        'stream' => \&stream_handler,
        'stream_initiated' => \&stream_initiated_handler,
        'stream_terminated' => \&stream_terminated_handler,

        'update_snapshots' => \&update_snapshots_handler,
        'snapshot_updated' => \&snapshot_updated_handler,
        'thumbnail_updated' => \&thumbnail_updated_handler,
    );
};

# broadcast a command for a given camera
sub camera_broadcast {
    my ($self, $camera, $command, $opts) = @_;

    croak "camera required" unless $camera;
    croak "command requires" unless $command;

    $opts ||= {};

    my @connections = $self->connections_for_camera($camera);
    foreach my $conn (@connections) {
        my $message = message($command, {
            %$opts,
            camera => $camera->serialize,
        });

        $conn->push_message($message);
    }
}

# returns client connections for a given camera
sub connections_for_camera {
    my ($self, $camera) = @_;

    croak "camera required" unless $camera;
    return unless $camera->host;

    return $self->connections_for_host($camera->host);
}

# call something periodically
# $id must be unique
sub set_timer {
    my ($self, $id, $interval, $cb) = @_;

    # snapshot refresh
    my $t = AnyEvent->timer(
        interval => $interval,
        cb => $cb,
    );
    $self->save_timer($id => $t);
}

# push out server configs to client, request clients to send their configs, sync
sub server_sync_all {
    my ($self) = @_;

    $self->push_sync_all;
    $self->request_sync_all;
    $self->request_sync_all;
}


### Handlers

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
        $self->camera_broadcast($camera => 'update_snapshot');
    }
}

sub update_thumbnails_handler {
    my ($self, $msg) = @_;

    my $cameras = $schema->resultset('Camera')->search({});
    while (my $camera = $cameras->next) {
        $self->camera_broadcast($camera => 'update_thumbnail');
    }
}

# takes message, parses out image and metadata
# returns Panoptic::Image
sub _image_received {
    my ($self, $msg) = @_;

    my $params = $msg->params;
    my $camera_id = $params->{camera_id}
        or return $msg->reply_error("camera_id missing");
    my $image_data = $params->{image}
        or return $msg->reply_error("image missing");
    my $content_type = $params->{content_type};

    my $camera = $schema->resultset('Camera')->find($camera_id)
        or return $msg->reply_error("camera:$camera_id not valid");

    my $image = Panoptic::Image->new(
        camera => $camera,
        image_data => \$image_data,
        content_type => $content_type,
    );

    return $image;
}

sub snapshot_updated_handler {
    my ($self, $msg) = @_;

    my $image = $self->_image_received($msg) or return;
    $image->camera->set_snapshot($image);
}

sub thumbnail_updated_handler {
    my ($self, $msg) = @_;

    my $image = $self->_image_received($msg) or return;
    $image->camera->set_thumbnail($image);
}

__PACKAGE__->meta->make_immutable;
