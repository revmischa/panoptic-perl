package Panoptic::S3::Storage;

# This is a moose role that adds support for fetching and storing S3 objects

use Moose::Role;
use namespace::autoclean;
use Carp qw/croak/;
use Panoptic::S3;
use Panoptic::Common qw/$log/;

requires 's3_folder';

has 's3' => (
    is => 'ro',
    isa => 'Panoptic::S3',
    lazy_build => 1,
);

sub _build_s3 { Panoptic::S3->new }

# returns a URI to a file on S3
# $key is REQUIRED
sub s3_uri {
    my ($self, $key) = @_;

    croak "key required for s3_uri" unless $key;

    my @path_parts = grep { $_ } (
        'https://s3.amazonaws.com',
        $self->s3->panoptic_bucket_name,
        $self->s3_path_to($key),
    );

    return join('/', @path_parts);
}

# folder/$key
sub s3_path_to {
    my ($self, $key) = @_;

    croak "key required for s3_path_to" unless $key;
    
    my @path_parts = grep { $_ } (
        $self->s3_folder,
        $key,
    );
    
    return join('/', @path_parts);
}

sub s3_upload {
    my ($self, $key, $value, $opts) = @_;

    croak "key required for s3_upload" unless $key;

    # key path
    my $path = $self->s3_path_to($key);

    # upload
    my $bucket = $self->s3->panoptic_bucket;
    unless ($bucket->add_key($path, $value, $opts)) {
        $log->error("Error uploading $key to S3: " .
                        $bucket->err . $bucket->errstr);
    }
}

sub s3_get {
    my ($self, $key) = @_;

    croak "key required for s3_get" unless $key;

    # key path
    my $path = $self->s3_path_to($key);

    # get val
    my $bucket = $self->s3->panoptic_bucket;
    my $val = $bucket->get_key($path);
    unless ($val) {
        $log->warn("Failed to get value for S3 key $key: " .
                       $bucket->err . $bucket->errstr);
    }

    return $val;
}

1;
