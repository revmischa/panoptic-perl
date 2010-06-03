#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Int80::Schema::IDB;

my $schema = Int80::Schema::IDB->get_connection;
$schema->deploy({ add_drop_table => 1 });
