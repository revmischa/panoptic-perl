# This contains code that is common to the panoptic server and client

package Panoptic::API;

use Moose::Role;
with 'Rapid::API';

before 'run' => sub {
    my ($self) = @_;
    
    $self->register_callbacks(
        sync => \&sync_handler,
        request_sync => \&request_sync_handler,
    );
};

# got a request to send our configuration
sub request_sync_handler {
    my ($self, $msg, $conn) = @_;

    # what are we being requested to sync?
    my $rs = $msg->params->{data_source};
    
    if ($rs) {
        # specific result source requested
        $self->push_sync($rs);
    } else {
        # nothing specific requested, push all
        $self->push_sync_all;
    }
}

# got some configuration data pushed at us
# merge it with our local config
sub sync_handler {
    my ($self, $msg, $conn) = @_;

    # what are we syncing?
    my $rs = $msg->params->{data_source};
    return $conn->push_error("Got sync info with no data_source specified")
        unless $rs;

    my $update = $msg->params->{update} or return; # nothing to update

    # do update
    # ...
}

# push out new configs
sub push_sync_all {
    my ($self) = @_;

    # stub
    #$self->push_sync('Camera');
}

# send a request for clients to sync
sub request_sync_all {
    my ($self) = @_;

    $self->broadcast(message('request_sync'));
}

# send out the current state of our config for $rs
sub push_sync {
    my ($self, $rs) = @_;

}

1;
