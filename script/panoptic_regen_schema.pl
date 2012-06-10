#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Panoptic::Script::RegenerateSchema;

###

my $script = Panoptic::Script::RegenerateSchema->new;
$script->run;
