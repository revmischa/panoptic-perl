use utf8;
package Panoptic::Schema::PDB::Result::CameraModel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("camera_model");
__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "camera_model_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "snapshot_uri",
  { data_type => "text", is_nullable => 1 },
  "default_h264_rtsp_uri",
  { data_type => "text", is_nullable => 1 },
  "mjpeg_uri",
  { data_type => "text", is_nullable => 1 },
  "mpeg4_rtsp_uri",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("camera_model_name_key", ["name"]);
__PACKAGE__->has_many(
  "cameras",
  "Panoptic::Schema::PDB::Result::Camera",
  { "foreign.model" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-06-16 20:21:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m/ecjTCgD85EB7UemBXkHQ


with 'Rapid::Storage';
__PACKAGE__->serializable(qw/ id name default_h264_rtsp_uri mjpeg_uri mpeg4_rtsp_uri snapshot_uri /);

__PACKAGE__->meta->make_immutable;
1;
