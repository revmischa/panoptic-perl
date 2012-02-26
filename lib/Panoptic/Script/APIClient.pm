package Panoptic::Script::APIClient;

use Any::Moose;
    with 'Panoptic::Script';

use AnyEvent;

sub run {
    my ($self) = @_;

    my $c = $self->container;

    my $cv = AE::cv;

    my $client = $c->fetch('/Panoptic/API/client')->get;
    $client->start_interactive_console;
    $client->run;
    $cv->recv;
}

1;
