package Panoptic::S3::File;

# This represents a file stored on S3

use Moose;
use namespace::autoclean;

use Panoptic::S3;
use Panoptic::Common qw/$log/;
use DateTime;
use Carp qw/croak/;

has 'key' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'folder' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

# get URI with auth param to access file
# note: link expires
has 'uri' => (
    is => 'rw',
    isa => 'Maybe[Str]',
    lazy_build => 1,
);

has 's3' => (
    is => 'ro',
    isa => 'Panoptic::S3',
    lazy_build => 1,
    handles => {
        'bucket' => 'panoptic_bucket',
    },
);

sub _build_s3 { Panoptic::S3->new }

# returns a URI to a file on S3
# N.B.: URI will expire in several days
sub _build_uri {
    my ($self) = @_;

    # expire image URI param key soon
    my $expire = time() + 3600 * 24 * 2; # two days

    my $path = $self->key_path;
    my $s3 = $self->s3;
    my $bucket = $self->bucket;

    # do request to get URI
    my $uri = Net::Amazon::S3::Request::GetObject->new(
        s3     => $bucket->account,
        bucket => $bucket->bucket,
        key    => $path,
        method => 'GET',
    )->query_string_authentication_uri($expire);

    unless ($uri) {
        $log->warn("Failed to get S3 query_string_authentication_uri for $path");
        return;
    }

    return $uri->as_string;
}

# folder/$key
sub key_path {
    my ($self) = @_;

    my @path_parts = grep { $_ } (
        $self->folder,
        $self->key,
    );
    @path_parts = map { lc($_) } @path_parts;

    return join('/', @path_parts);
}

sub upload {
    my ($self, $valueref, $opts) = @_;

    croak "value is required for upload" unless $valueref;
    my $value = ref($valueref) ? $$valueref : $valueref;

    # key path
    my $path = $self->key_path;

    # upload
    my $bucket = $self->bucket;
    unless ($bucket->add_key($path, $value, $opts)) {
        $log->error("Error uploading $path to S3: " .
                        $bucket->err . $bucket->errstr);
        return;
    }

    return 1;
}

sub content {
    my ($self) = @_;

    # key path
    my $path = $self->key_path;

    # get val
    my $bucket = $self->bucket;
    my $val = $bucket->get_key($path);
    unless ($val) {
        $log->warn("Failed to get value for S3 key $path: " .
                       $bucket->err . $bucket->errstr);
    }

    return $val;
}

__PACKAGE__->meta->make_immutable;
