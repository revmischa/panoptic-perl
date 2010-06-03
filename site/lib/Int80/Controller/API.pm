package Int80::Controller::API;
 
use Moose;
use namespace::autoclean;
 
BEGIN { extends 'Catalyst::Controller'; }
 
sub api_base : Chained('/') PathPart('api') CaptureArgs(0) {
    my ( $self, $c ) = @_;
}
 
__PACKAGE__->meta->make_immutable;
