# Panoptic Server
# Mischa S.
# Sept. 2011

# Panoptic clients connect to this server and register themselves,
# synchronize configs, and respond to stream initiation requests

package Panoptic::API::Server;

use Moose;
extends 'Rapit::API::Server::Async';

before 'run' => sub {
    my ($self) = @_;
    
    $self->register_callbacks(
    );
};

# sub echo {
#     my ($self, $msg, $conn) = @_;

#     $conn->push($msg->command, {
#         %{ $msg->params },
#         echo => 1,
#     })
# }

__PACKAGE__->meta->make_immutable;
