package Curs::App::Controller::Auth;
use Moose; use namespace::autoclean;
BEGIN {extends 'Catalyst::Controller'; }
use Curs::App::Form::Login;

=head2 login
=cut
sub login : Path(/login) Args(0) {
    my ( $self, $c ) = @_;
    my $form = Curs::App::Form::Login->new();

    if ( $form->process( params => $c->req->params ) ) {
        # login here!
        if ( $c->authenticate( { 
                email    => $form->value->{email}, 
                password => $form->value->{password}
            } ) ) 
        {
            $c->detach('after_login_redirect');
        }
        else {
            $form->field('password')->add_error( 'Invalid password' );
        }
    }

    $c->stash( 
        template => 'auth/login.tt',
        form     => $form
    );
}

=head2 after_login_redirect
 Ensure a user is redirected after a login success.
=cut
sub after_login_redirect : Private {
    my ( $self, $c ) = @_;
    my $path = delete $c->session->{after_login_path} || '/';
    $c->res->redirect( $c->uri_for( $path ) );
}

=head2 need_login
 Base method for admin chains that needs a user logged in.
=cut
sub need_login : PathPart( '' ) Chained( '/' ) CaptureArgs( 0 ) {
    my ( $self, $c ) = @_;

    unless ( $c->user_exists ) {
        $c->session->{after_login_path} = '/' . $c->req->path;
        $c->res->redirect( 
            $c->uri_for_action( 
                $c->controller('Auth')->action_for('login') 
            ) 
        );
        $c->detach;
    }
}

=head2 need_role_admin
 Base method for actions that need a user with the admin role.
=cut
sub need_role_admin : PathPart( 'admin' ) Chained( 'need_login' ) CaptureArgs( 0 ) {
    my ( $self, $c ) = @_;
    unless ( $c->check_user_roles( 'admin' ) ) {
        $c->res->body('You need admin role for this action!');
        $c->detach();
    }
}

=head2 logout
=cut
sub logout : Path(/logout) Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;
    $c->res->redirect( 
        $c->uri_for_action( 
            $c->controller('Auth')->action_for('login') 
        ) 
    );
}

__PACKAGE__->meta->make_immutable;

1;
