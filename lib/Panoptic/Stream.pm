# This represents an AV stream

package Panoptic::Stream;

use Moose;
use Rapid::UUID;
use AV::Streamer;
use AnyEvent;
use namespace::autoclean;

has 'id' => (
    is => 'rw',
    isa => 'Str',
    lazy_build => 1,
);

has 'camera_id' => (
    is => 'rw',
    isa => 'Maybe[Integer]',
);

has 'uri' => (
    is => 'rw',
    isa => 'Str',
);

has 'dest' => (
    is => 'rw',
#    isa => 'Str',
#    required => 1,
);

has 'streamer' => (
    is => 'rw',
    isa => 'AV::Streamer',
    lazy_build => 1,
    clearer => 'clear_streamer',
    handles => [ qw/
        add_output add_audio_stream add video_stream set_metadata
        close
    / ],
);

has '_stream_timer' => (
    is => 'rw',
    clearer => '_clear_stream_timer',
);

sub _build_id { Rapid::UUID->create }

sub _build_streamer {
    my ($self) = @_;

    my $s = AV::Streamer->new;
    return $s;
}

# open $self->uri, returns success
sub open_input {
    my ($self) = @_;

    $self->streamer->open_uri($self->uri) or return;

    my $output = $self->add_output(
        uri => 'tcp://localhost:6666',
        format => 'flv',
        bit_rate => 100_000,
    );

    $output->add_video_stream(
        codec => 'copy',
    );
    
    return 1;
}

# begin streaming
sub play {
    my ($self) = @_;

    my $w = AnyEvent->timer(
        interval => ( 1 / 30 ),  # TODO: should be stream FPS
        cb => sub { $self->stream_frame },
    );

    $self->_stream_timer($w);
}

# called periodically to stream a frame to dest
sub stream_frame {
    my ($self) = @_;

    my $s = $self->streamer;
    if ($s->finished_streaming || ! $s->stream_frame) {
        # we're done, go home
        $self->terminate;
        return;
    }
}

sub terminate {
    my ($self) = @_;

    $self->_clear_stream_timer;
    $self->clear_streamer;
}

__PACKAGE__->meta->make_immutable;
