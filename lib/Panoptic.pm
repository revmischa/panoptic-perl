package Panoptic;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'Panoptic',
);

__PACKAGE__->setup;

###

sub msg {
    my ($c, $msg) = @_;
    $c->flash->{messages} ||= [];
    push @{$c->flash->{messages}}, $msg if $msg;
}

sub get_notifications {
    my ($c) = @_;

    my $msgs = delete $c->flash->{messages} || [];
    return $msgs;
}

###

1;
