package Curs::App::Form::Login;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use Email::Valid;

has_field 'email' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { Email::Valid->address( $_[0] ) },
        message => 'Must be a valid email address'
    }
]);
has_field 'password' => ( type => 'Password', required => 1 );

has_field 'submit' => ( type => 'Submit', value => 'Login' );

no HTML::FormHandler::Moose;

1;
