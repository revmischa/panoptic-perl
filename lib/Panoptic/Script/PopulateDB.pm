package Panoptic::Script::PopulateDB;

use Moose;
use Panoptic::Common qw/$schema/;
with 'Panoptic::Script';
use feature 'say';

sub run {
    my ($self) = @_;

    say "Populating initial database info";
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
    foreach my $model (@models) {
        my $row = $$schema->resultset('CameraModel')->find_or_create({ name => $model->{name} });
        $row->update($model);
    }
    say "Updated camera models";
}

1;
