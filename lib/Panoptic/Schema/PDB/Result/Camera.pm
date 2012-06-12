package Panoptic::Schema::PDB::Result::Camera;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("camera");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "camera_id_seq",
  },
  "uri",
  { data_type => "text", is_nullable => 1 },
  "host",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "location_desc",
  { data_type => "text", is_nullable => 1 },
  "snapshot_s3_key",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2012-06-11 19:39:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hR9N138ud/z0Wu6fe8Sf3w

use Panoptic::Common qw/$config/;
use Panoptic::S3;
use Data::UUID;

sub local_snapshot_uri {
    my ($self) = @_;

    return "http://axis1.int80/jpg/image.jpg";
}

sub s3_snapshot_uri {
    my ($self) = @_;

    return "https://s3.amazonaws.com/" . Panoptic::S3->panoptic_bucket_name . '/' . $self->snapshot_s3_key;
}

# snapshot = image data
# meta = hashref of metadata (content_type, ...)
sub set_snapshot {
    my ($self, $snapshot, $meta) = @_;

    my $bucket = Panoptic::S3->new->panoptic_bucket;
    my $img_key = $self->find_or_create_snapshot_s3_key;
    $bucket->add_key($img_key, $snapshot, $meta)
        or die $bucket->err . $bucket->errstr;
}

sub get_snapshot {
    my ($self) = @_;

    my $img_key = $self->snapshot_s3_key;
    return unless $img_key;

    my $bucket = Panoptic::S3->new->panoptic_bucket;
    my $snapshot = $bucket->get_key($img_key)
        or die $bucket->err . $bucket->errstr;

    return $snapshot;
}

sub find_or_create_snapshot_s3_key {
    my ($self) = @_;

    my $key = $self->snapshot_s3_key;
    return $key if $key;

    # generate key
    $key = Data::UUID->new->create_from_name_str('biz.int80.panoptic', 'camera_snapshot');
    $self->snapshot_s3_key($key);
    $self->update;

    return $key;
}

1;
