package Panoptic::Script::PopulateDB;

use Moose;
use Panoptic::Common qw/$schema/;
with 'Panoptic::Script';
use feature 'say';

sub run {
    my ($self) = @_;

    my $ok = shift @ARGV;
    die "run this with YES as the first argument to srsly populate the db ok\n"
        unless $ok && $ok eq 'YES';

    say "Inserting initial data into DB";
    $self->insert_camera_models;
}

sub insert_camera_models {
    my @models = (
        {
            name => 'Axis 207MW',
            mjpeg_uri => '/mjpg/video.mjpg',
            mpeg4_rtsp_uri => '/mpeg4/media.amp',
            snapshot_uri => '/jpg/image.jpg',
        },
        {
            name => 'Axis 209MFD',
            mjpeg_uri => '/mjpg/video.mjpg',
            mpeg4_rtsp_uri => '/mpeg4/media.amp',
            snapshot_uri => '/jpg/image.jpg',
        },
        {
            name => 'Axis P3344',
            mjpeg_uri => '/axis-cgi/mjpg/video.cgi',
            snapshot_uri => '/axis-cgi/jpg/image.cgi',
            default_h264_rtsp_uri => '/axis-media/media.amp',
        },
        {
            name => 'D-Link DCS-6110',
            mjpeg_uri => '/video.mjpg',
        },
        {
            name => 'IQEye IA10S',
            snapshot_uri => '/now.jpg',
        },
    );
    $schema->resultset('CameraModel')->populate(\@models);
    say "Inserted camera models";
}

1;
