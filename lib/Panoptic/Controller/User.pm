package Panoptic::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub logout :Local {
    my ($self, $c) = @_;

    $c->logout;
    $c->res->redirect('/');
}

sub login :Local {
    my ($self, $c) = @_;

    my $username = $c->req->param('username');
    my $redir = $c->req->param('redir');
    if ($username) {
        my $ok = $self->authenticate($c);

        if ($ok) {
            $redir ||= '/';
            $c->res->redirect($redir);
            return;
        } else {
            $c->stash->{login_error} = "Invalid login";
        }
    }

    $c->stash(
        redir => $redir,
        template => 'user/login.tt',
    );
}

sub authenticate {
    my ($self, $c) = @_;

    my $username = $c->req->param('username');
    my $password = $c->req->param('password');

    my $args = {
        'dbix_class' => {
            searchargs => [ {
                '-or' => [
                    username => $username,
                    email    => $username,
                ],
            } ],
        },
        password => $password,
    };
    
    # try customer, admin realms
    return $c->authenticate($args, 'customer') || $c->authenticate({
        username => $username,
        password => $password,
    }, 'admin');
}

__PACKAGE__->meta->make_immutable;

1;