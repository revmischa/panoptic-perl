package Panoptic::S3::Storage;

# This is a moose role that adds support for fetching and storing S3 objects

use Moose::Role;
use namespace::autoclean;
use Carp qw/croak/;
use Panoptic::S3::File;

requires 's3_folder';

sub s3_file {
    my ($self, $key) = @_;

    croak "key is required for s3_file" unless $key;
    return Panoptic::S3::File->new(
        key => $key,
        folder => $self->s3_folder,
    );
}

1;
