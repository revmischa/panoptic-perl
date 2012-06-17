package Panoptic::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub logout :Local {
    my ($self, $c) = @_;

    $c->logout;
    $c->res->redirect('/');
}

sub login_demo :Local {
    my ($self, $c) = @_;

    return unless $c->config->{demo_enabled};
    my $user = $c->model('PDB::User')->first;
    $self->set_authenticated_user($c, $user);

    $c->forward('post_login');
}

sub set_authenticated_user {
    my ($self, $c, $user) = @_;

    $c->logout;

    # log in user
    $c->set_authenticated(
        $c->find_user({ id => $user->id })
    );
}

sub login :Local {
    my ($self, $c) = @_;

    my $username = $c->req->param('username');
    if ($username) {
        my $ok = $self->authenticate($c);

        if ($ok) {
            $c->go('post_login');
        } else {
            $c->stash->{login_error} = "Invalid login";
        }
    }

    my $redir = $c->req->param('redir');
    $c->stash(
        redir => $redir,
        template => 'user/login.tt',
    );
}

sub post_login :Private {
    my ($self, $c) = @_;

    my $redir = $c->req->param('redir');
    $redir ||= '/';
    $c->res->redirect($redir);
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
