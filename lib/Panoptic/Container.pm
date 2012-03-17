# Panoptic::Container

# This Bread::Board container adds panoptic-specific containers and
# services to the base container provided by Rapid

package Panoptic::Container;

use Moose;
use Bread::Board;
use Panoptic::API::Server;

extends 'Rapid::Container';

has '+name' => ( default => 'PanopticBase' );

sub BUILD {
    my ($self) = @_;

    # here we add panoptic-specific containers and services
    container $self => as {
        service 'app_name' => 'panoptic';
        
        container 'Panoptic' => as {
            container 'API' => as {
                # API server
                service 'server' => (
                    class        => 'Panoptic::API::Server',
                    dependencies => {
                        port => depends_on('/API/port'),
                        host => depends_on('/API/host'),
                    },
                );

                # Perl API client
                service 'client' => (
                    class        => 'Panoptic::API::Client',
                    dependencies => {
                        port => depends_on('/API/port'),
                        host => depends_on('/API/host'),
                    },
                );
            };
        };
    };
}

__PACKAGE__->meta->make_immutable;
