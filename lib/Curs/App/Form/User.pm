package Curs::App::Form::User;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

use Email::Valid;

has '+item_class' => ( default => 'User' );

has_field 'name' => ( type => 'Text', required => 1 );
has_field 'email' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { Email::Valid->address( $_[0] ) },
        message => 'Must be a valid email address'
    }
]);
has_field 'password' => ( type => 'Password', required => 1 );
has_field 'password_conf' => ( type => 'PasswordConf', required => 0 );

has_field 'roles' => ( 
    type => 'Select', 
    multiple => 1, 
    widget => 'CheckboxGroup',
    sort_column => 'name',
    input_without_param => [], 
    not_nullable => 1
);

has_field 'submit' => ( type => 'Submit', value => 'Save' );

no HTML::FormHandler::Moose;

1;
