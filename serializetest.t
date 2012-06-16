#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use lib '../rapid/lib';

use Panoptic::Common qw/$schema/;
use Data::Dump qw/ddx/;

my $camera = $schema->resultset('Camera')->first;

ddx($camera->pack);
