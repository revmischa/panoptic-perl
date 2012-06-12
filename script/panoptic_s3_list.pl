#!/usr/bin/env perl

use strict;
use warnings;

my $script = Panoptic::Script::S3List->new;
$script->run;

###

package Panoptic::Script::S3List;
use Moose;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Panoptic::S3;

with 'Panoptic::Script';

sub run {
    my $s3 = Panoptic::S3->new;

    my $response = $s3->buckets;
    foreach my $bucket ( @{ $response->{buckets} } ) {
        print "Bucket found: " . $bucket->bucket . "\n";
    }
}
