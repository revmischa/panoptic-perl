# Panoptic Client
# Mischa S.
# Sept. 2011

# The client initiates outbound connections to a panoptic perl server
# It listens for events from the server that tell it when to
# synchronize configurations, initiate video streams, etc

package Panoptic::API::Client;

use Moose;
use AnyEvent;
use Panoptic::Stream;
use namespace::autoclean;

extends 'Rapid::API::Client::Async';
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
        all_streams => 'values',
    },
);

before 'run' => sub {
    my ($self) = @_;

    $self->register_callbacks(
        initiate_stream => \&initiate_stream_handler,
        terminate_stream => \&terminate_stream_handler,
        disconnect => \&disconnect_handler,
    );

    # catch interrupts, clean up streams
    my $oldhandler = $SIG{INT};
    $SIG{INT} = sub {
        $self->cleanup;
        $oldhandler->(@_) if $oldhandler;
        exit 0;
    };
};

sub cleanup {
    my ($self) = @_;
    
    $_->terminate for $self->all_streams;
}

sub disconnect_handler {
    my ($self, $msg) = @_;

    # error message and disconnection are automatically handled
}

sub initiate_stream_handler {
    my ($self, $msg) = @_;

    # accept camera ID or a URI
    my $camera_id  = $msg->params->{camera_id};
    my $input_uri  = $msg->params->{input_uri};
    my $output_uri = $msg->params->{output_uri};

    return $self->push_error("camera_id or input_uri required for initiate_stream")
        unless $camera_id || $input_uri;

    return $self->push_error("output_uri required for initiate_stream") unless $output_uri;
    
    # create stream
    my $stream = Panoptic::Stream->new(
        camera_id  => $camera_id,
        input_uri  => $input_uri,
        output_uri => $output_uri,
        #dest       => $self->config->{rtmpd_server},
    );

    # keep track of stream
    my $id = $stream->id;
    $self->set_stream($id => $stream);

    # open input
    unless ($stream->open_input) {
        return $self->push_error("Failed to open stream input for URI " .
                                 $stream->input_uri);
    }        
    
    # start stream
    unless ($stream->play) {
        return $self->push_error("Failed to start stream for output " . $stream->output_uri);
    }

    # return success
    $self->push_message(message('stream_initiated', { stream_id => $id }));
}

sub terminate_stream_handler {
    my ($self, $msg) = @_;

    my $stream_id = $msg->params->{stream_id}
        or return $self->push_error("stream_id is required for terminate_stream");
    
    my $stream = $self->get_stream($stream_id)
        or return $self->push_error("Unknown stream");

    $stream->terminate;
    $self->delete_stream($stream_id);

    $self->push_message(message('stream_terminated', { stream_id => $stream_id }));
}

__PACKAGE__->meta->make_immutable;