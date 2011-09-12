#!/usr/bin/env perl

# This runs the /Panoptic/API/client service

use Moose;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Panoptic::Container;
use AnyEvent;

my $c = Panoptic::Container->new(
    app_root => "$FindBin::Bin/..",
);

my $cv = AE::cv;

my $client = $c->fetch('/Panoptic/API/client')->get;
$client->start_interactive_console;
$client->run;
$cv->recv;
