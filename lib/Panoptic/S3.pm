package Panoptic::S3;

# interface to store and retrieve files in S3

use Moose;
use namespace::autoclean;
use Panoptic::Common qw/$config/;
use MooseX::NonMoose;
extends 'Net::Amazon::S3';

has 'aws_access_key_id' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    lazy_build => 1,
);

has 'aws_secret_access_key' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
    lazy_build => 1,
);

sub _build_aws_access_key_id { $config->{aws}{access_key_id} or die "aws.access_key_id not found in config" }
sub _build_aws_secret_access_key { $config->{aws}{secret_access_key} or die "aws.secret_access_key not found in config" }

__PACKAGE__->meta->make_immutable;
