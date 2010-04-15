package Int80::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');


# index page
sub index :Private {
    my ( $self, $c ) = @_;
}

# other root pages
sub contact :Local {}
# ...

# 404
sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

# end
sub end : ActionClass('RenderView') {}


__PACKAGE__->meta->make_immutable;

1;
