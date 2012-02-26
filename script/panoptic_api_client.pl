#!/usr/bin/env perl

# This runs the /Panoptic/API/client service

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Panoptic::Script::APIClient;

my $script = Panoptic::Script::APIClient->new;
$script->run;
