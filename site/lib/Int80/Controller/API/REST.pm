package Int80::Controller::API::REST;
 
use Moose;
use namespace::autoclean;
 
BEGIN { extends 'Catalyst::Controller::DBIC::API::REST'; }
 
sub rest_base : Chained('/api/api_base') PathPart('rest') CaptureArgs(0) {
    my ($self, $c) = @_;
}
 
__PACKAGE__->meta->make_immutable;