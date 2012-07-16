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

has 'info' => (
    is => 'rw',
    isa => 'Maybe[HashRef[Str]]',
    lazy_build => 1,
);

sub _build_info {
    my ($self) = @_;
    
    my $img = $self->_image or return;
    return {
        width  => $img->getwidth,
        height => $img->getheight,
    }
}

sub width {
    my ($self) = @_;
    my $info = $self->info or return;
    return $info->{width};
}
sub height {
    my ($self) = @_;
    my $info = $self->info or return;
    return $info->{height};
}

sub _image {
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
    
    return $img;
}

# make square thumbnail
sub generate_square_thumbnail {
    shift->_generate_thumbnail(1);
}

# preserve aspect ratio
sub generate_aspect_thumbnail {
    shift->_generate_thumbnail(0);
}

sub _generate_thumbnail {
    my ($self, $crop) = @_;

    my $img = $self->_image;
    my $thumb_size = $config->{camera}{snapshot}{thumbnail_size} || 80;

    # scale thumbnail down
    my $thumb = $img->scale(
        xpixels => $thumb_size,
        ypixels => $thumb_size,
        type  => 'max',     # keep aspect ratio, use largest dimension
    );

    # crop thumbnail to square
    $thumb = $thumb->crop(
        width => $thumb_size,
        height => $thumb_size,
    ) if $crop;

    # write cropped, scaled thumbnail data
    my $thumb_format = $config->{camera}{snapshot}{thumbnail_format} || 'image/png';
    my ($imager_thumb_format) = $thumb_format =~ m!/(\w+)$!;
    my $thumb_data = "";
    $thumb->write(
        data => \$thumb_data,
        type => $imager_thumb_format,
    );

    if (! $thumb_data) {
        $log->warn("Unknown error writing out thumbnail as $thumb_format");
        return;
    }

    my %ret_img = (
        image_data => \$thumb_data,
        content_type => $thumb_format,
    );
    $ret_img{camera} = $self->camera if $self->camera;

    my $ret = __PACKAGE__->new(%ret_img);
    return $ret;
}

__PACKAGE__->meta->make_immutable;

