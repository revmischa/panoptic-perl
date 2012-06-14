package Panoptic::Controller::API;

use strict;
use warnings;

use parent 'Catalyst::Controller';

sub api_base :Chained('/') PathPart('api') CaptureArgs(0) {}

1;
