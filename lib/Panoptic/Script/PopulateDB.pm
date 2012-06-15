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
            name => 'Axis 205MW',
            mjpeg_uri => '/mjpg/video.mjpg',
        },
    );
    $schema->resultset('CameraModel')->populate(\@models);
    say "Inserted camera models";
}

1;
