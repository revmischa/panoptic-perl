# Panoptic Client
# Mischa S.
# Sept. 2011

# The client initiates outbound connections to a panoptic perl server
# It listens for events from the server that tell it when to
# synchronize configurations, initiate video streams, etc

package Panoptic::API::Client;

use Moose;
use AnyEvent;
use namespace::autoclean;

extends 'Rapit::API::Client::Async';
with 'Panoptic::API';

has 'streams' => (
    is => 'rw',
    isa => 'HashRef[Panoptic::Stream]',
    traits => ['Hash'],
    handles => {
        get_stream => 'get',
        set_stream => 'set',
        has_stream => 'exists',
        delete_stream => 'delete',
    },
);

before 'run' => sub {
    my ($self) = @_;

    $self->register_callbacks(
        initiate_stream => \&initiate_stream_handler,
        terminate_stream => \&terminate_stream_handler,
    );
};

sub initiate_stream_handler {
    my ($self, $msg, $conn) = @_;

    # accept camera ID or a URI
    my $camera_id = $msg->params->{camera_id};
    my $uri = $msg->params->{uri};

    return $conn->push_error("camera_id or uri required for initiate_stream")
        unless $camera_id || $uri;

    # create stream
    my $stream = Panoptic::Stream->new(
        camera_id => $camera_id,
        uri       => $uri,
        dest      => $conn,
    );

    # keep track of stream
    my $id = $stream->id;
    $self->set_stream($id => $stream);

    # start stream
    unless (eval { $stream->play }) {
        my $why = $@ || "unknown error";
        $conn->push_error("Failed to start stream: $why");
    }

    # return success
    $conn->push_message(message('stream_initiated', { stream_id => $id }));
}

sub terminate_stream_handler {
    my ($self, $msg, $conn) = @_;

    my $stream_id = $msg->params->{stream_id}
        or return $conn->push_error("stream_id is required for terminate_stream");
    
    my $stream = $self->get_stream($stream_id)
        or return $conn->push_error("Unknown stream");

    $stream->terminate;
    $self->delete_stream($stream_id);

    $conn->push_message(message('stream_terminated', { stream_id => $stream_id }));
}

__PACKAGE__->meta->make_immutable;
