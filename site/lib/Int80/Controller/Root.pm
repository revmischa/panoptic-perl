package Int80::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub stylesheet :Path('global.css') {
    my ($self, $c) = @_;
    
    $c->stash(
        current_view => 'TT',
        template => 'global.css.tt2',
    );
}

sub login :Local {
    my ($self, $c) = @_;
    
    $c->stash->{template} = 'login.tt2';
    
    my $user = $c->req->param("username")
        or return;
        
    my $pass = $c->req->param("password")
        or return $c->user_error("Please enter your password");

    my $ok = $c->authenticate({
        username => $user,
        password => $pass,
    });
    
    if ($ok) {
        $c->msg("You are now logged in as $user");
        $c->forward('/');
    } else {
        $c->stash->{invalid_login} = 1;
    }
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

