package Panoptic::Image;

# image manipulation functions

use Moose;
use namespace::autoclean;
use Carp qw/croak/;
use Imager;
use Panoptic::Common qw/$config $log/;

has 'image_data' => (
    is => 'rw',
    isa => 'ScalarRef',
    required => 1,
);

# mime content-type
has 'content_type' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has 'camera' => (
    is => 'rw',
    isa => 'Panoptic::Schema::PDB::Result::Camera',
);

sub generate_thumbnail {
    my ($self) = @_;

    # TODO: should figure this out from content_type
    my $type = 'jpeg';

    # load image up into Imager
    my $img = Imager->new(
        data => ${ $self->image_data },
        type => $type,
    );

    unless ($img) {
        $log->warn("Error loading snapshot into Imager for thumbnailing: " . Imager->errstr);
        return;
    }

    my $thumb_size = $config->{camera}{snapshot}{thumbnail_size} || 80;

    # scale thumbnail down
    my $scaled_thumb = $img->scale(
        xpixels => $thumb_size,
        ypixels => $thumb_size,
        type  => 'max',     # keep aspect ratio, use largest dimension
    );

    # crop thumbnail to square
    my $cropped_thumb = $scaled_thumb->crop(
        width => $thumb_size,
        height => $thumb_size,
    );

    # write cropped, scaled thumbnail data
    my $cropped_thumb_data = "";
    $cropped_thumb->write(
        data => \$cropped_thumb_data,
        type => 'png',
    );

    if (! $cropped_thumb_data) {
        $log->warn("Unknown error writing out thumbnail PNG");
        return;
    }

    my $ret = __PACKAGE__->new(
        image_data => \$cropped_thumb_data,
        content_type => 'image/png',
        camera => $self->camera,
    );
    return $ret;
}

__PACKAGE__->meta->make_immutable;

