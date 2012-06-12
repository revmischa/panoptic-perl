package Panoptic::S3;

# interface to store and retrieve files in S3

use Moose;
use namespace::autoclean;
use Panoptic::Common qw/$config/;
extends 'Net::Amazon::S3';

has '+aws_access_key_id' => ( lazy_build => 1 );
has '+aws_secret_access_key' => ( lazy_build => 1 );
has '+retry' => ( default => 1 );
has '+secure' => ( default => 1 );

sub _build_aws_access_key_id { $config->{aws}{access_key_id} or die "aws.access_key_id not found in config" }
sub _build_aws_secret_access_key { $config->{aws}{secret_access_key} or die "aws.secret_access_key not found in config" }

sub panoptic_bucket { $_[0]->bucket($_[0]->panoptic_bucket_name) }

sub panoptic_bucket_name { $config->{aws}{bucket_name} or die "aws.bucket_name not found in config" }

__PACKAGE__->meta->make_immutable;
