#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Panoptic::Script::PopulateDB;

###

my $script = Panoptic::Script::PopulateDB->new;
$script->run;
