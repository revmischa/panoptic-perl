#!/usr/bin/env perl

# This runs the /Panoptic/API/server service

use Moose;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Panoptic::Container;
use AnyEvent;

my $c = Panoptic::Container->new(
    app_root => "$FindBin::Bin/..",
);

my $cv = AE::cv;

my $server = $c->fetch('/Panoptic/API/server')->get;
$server->start_interactive_console;
$server->run;
$cv->recv;

