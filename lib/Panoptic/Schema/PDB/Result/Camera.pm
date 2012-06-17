use utf8;
package Panoptic::Schema::PDB::Result::Camera;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
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
  "host",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "location_desc",
  { data_type => "text", is_nullable => 1 },
  "snapshot_s3_key",
  { data_type => "text", is_nullable => 1 },
  "has_thumbnail",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "model",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "customer",
  { data_type => "integer", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 0 },
  "username",
  { data_type => "text", is_nullable => 1 },
  "password",
  { data_type => "text", is_nullable => 1 },
  "snapshot_last_updated",
  { data_type => "timestamp", is_nullable => 1 },
  "thumbnail_last_updated",
  { data_type => "timestamp", is_nullable => 1 },
  "last_live_update",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "model",
  "Panoptic::Schema::PDB::Result::CameraModel",
  { id => "model" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-06-17 04:50:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I9lP4R8ALj4Lq8yBwng4rg

use Panoptic::Common qw/$config $log/;
use Panoptic::S3;
use Panoptic::Image;
use Rapid::UUID;
use Digest::SHA1;
use Imager;
use Carp qw/croak/;
use Moose;

with 'Panoptic::S3::Storage';
with 'Rapid::Storage';

__PACKAGE__->serializable(qw/ id model local_snapshot_uri username password /);

###

__PACKAGE__->belongs_to(
  "model",
  "Panoptic::Schema::PDB::Result::CameraModel",
  { id => "model" },
  {
      cascade_copy => 0,
      cascade_delete => 0,
      join_type     => "LEFT",
  },
);

__PACKAGE__->belongs_to(
  "host",
  "Rapid::Schema::RDB::Result::CustomerHost",
  { id => "host" },
  {
      cascade_copy => 0,
      cascade_delete => 0,
      join_type     => "LEFT",
  },
);

###

has local_snapshot_uri => (
    is => 'rw',
    isa => 'Str',
    lazy_build => 1,
);

###

sub _build_local_snapshot_uri {
    my ($self) = @_;

    # should make a URL builder thing
    return unless $self->host && $self->model;
    return 'http://' . $self->address . $self->model->snapshot_uri;
}

sub s3_folder { 'snapshot' }

sub s3_snapshot_uri {
    my ($self) = @_;

    return unless $self->snapshot_s3_key;
    return $self->s3_file($self->snapshot_s3_key)->uri;
}

sub s3_thumbnail_uri {
    my ($self) = @_;

    return unless $self->has_thumbnail;
    return $self->s3_file($self->thumbnail_s3_key)->uri;
}

sub set_snapshot {
    my ($self, $img) = @_;

    croak "set_snapshot called without image"
        unless $img;

    # set thumbnail, while we're at it
    $self->set_thumbnail($img->generate_thumbnail);

    # upload orig file
    my $img_key = $self->find_or_create_snapshot_s3_key;
    my $meta = { 'content-type' => $img->content_type };
    $self->s3_file($img_key)->upload($img->image_data, $meta);
    $self->update({ snapshot_last_updated => \ 'NOW()' });
}

sub set_thumbnail {
    my ($self, $thumb_img) = @_;

    # upload cropped thumbnail, if we got it
    if ($thumb_img) {
        # upload cropped thumb
        my $thumb_key = $self->thumbnail_s3_key;
        my $thumb_meta = { 'content-type' => $thumb_img->content_type };
        if ($self->s3_file($thumb_key)->upload($thumb_img->image_data, $thumb_meta)) {
            $self->has_thumbnail(1);
            $self->update({ thumbnail_last_updated => \ 'NOW()' });
        } else {
            $self->has_thumbnail(0);
        }
    } else {
        $self->has_thumbnail(0);
    }

    $self->update;
}

sub thumbnail_s3_key { shift->find_or_create_snapshot_s3_key . "_thumb" }

sub find_or_create_snapshot_s3_key {
    my ($self) = @_;

    my $key = $self->snapshot_s3_key;
    return $key if $key;

    # generate key
    $key = Digest::SHA1::sha1_hex(Rapid::UUID->create);
    $self->snapshot_s3_key($key);
    $self->update;

    return $key;
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
