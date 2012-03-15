#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Panoptic::Script::DeploySchema;

###

my $script = Panoptic::Script::DeploySchema->new;
$script->run;
