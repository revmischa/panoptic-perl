#!/usr/bin/env perl

# This runs the /Panoptic/API/server service

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Panoptic::Script::APIServer;

my $script = Panoptic::Script::APIServer->new;
$script->run;
