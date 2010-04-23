package Int80::Controller::Contact;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub do : Local {
    my ($self, $c) = @_;

    my $name = $c->req->param('name');
    my $phone = $c->req->param('phone');
    my $email = $c->req->param('email');
    my $request = $c->req->param('request');

    return $c->error("You must fill out at least some of the fields!")
        unless $name && $phone && $email && $request; # jenk is a fag

    my $contact = $c->model('IDB::Contact')->create({
        name => $name,
        phone => $phone,
        email => $email,
        request => $request,
    });
    
    $c->stash(
        name => $name,
		phone => $phone,
		email_address => $email,
		request => $request,
        email => {
    		to => $c->config->{contact_email_address},
    		from => $c->config->{sender_email_address},
    		subject => 'Auto-Generated Contact Form Request',
    		template => 'contact/notification_email.tt2',
    	},
    );
    
	$c->forward( $c->view('Email::Template') );
	
	$c->stash->{template} = 'contact/confirmation.tt2';
}

no Moose;
__PACKAGE__->meta->make_immutable;
