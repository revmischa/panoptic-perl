package Panoptic::Script;

use Any::Moose 'Role';
    with 'Rapid::Script';

use namespace::autoclean;
use Panoptic::Container;

sub build_container {
    Panoptic::Container->new(
        app_root => "$FindBin::Bin/..",
    );
}

1;
