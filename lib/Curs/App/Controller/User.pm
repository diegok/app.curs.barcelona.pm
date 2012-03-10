package Curs::App::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }
use Curs::App::Form::User;

=head2 list
List all users.
=cut
sub list : PathPart( 'users' ) Chained( '/auth/need_login' ) Args( 0 ) {
    my ( $self, $c ) = @_;
 
    my $users = $c->model('DB::User')->search( {}, {
        page => $c->req->params->{page} || 1,
        rows => 10,
        order_by => 'name ASC'
    });
 
    $c->stash(
        users    => [ $users->all ],
        pager    => $users->pager,
        template => 'user/list.tt'
    );
}
 
=head2 element_chain
Base chain for actions related to one user
=cut
sub element_chain : PathPart( 'user' ) Chained( '/auth/need_login' ) CaptureArgs( 1 ) {
    my ( $self, $c, $user_id ) = @_;
 
    unless ( $c->stash->{user} = $c->model('DB::User')->find( $user_id ) ) {
        $c->detach( '/error/element_not_found', [ 'user' ] );
    }
}
 
sub view : PathPart( '' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    $c->stash( template => 'user/view.tt' );
}

=head2 element_chain_admin
Base chain for admin actions related to one user.
This action will check for one of this:
    - Logged user has admin role
    - Logged user is the same as user element
=cut
sub element_chain_admin : PathPart( 'user' ) Chained( '/auth/need_role_admin' ) CaptureArgs( 1 ) {
    my ( $self, $c, $user_id ) = @_;
    $c->forward( element_chain => [$user_id] );
}

=head2 edit
Edit a user
=cut
sub edit : PathPart( 'edit' ) Chained( 'element_chain_admin' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $user = $c->stash->{user};

    my $form = Curs::App::Form::User->new;

    # Only user-admins can modify user roles
    $form->field('roles')->inactive(1) unless $c->check_user_roles('admin');
    $form->field('password')->required(0);

    if ( $form->process( item => $user, params => $c->req->params ) ) {
        $c->flash( message => 'User saved' );
        $c->res->redirect( $c->uri_for('/users') );
        if ($user->id == $c->user->obj->id) {
            $c->persist_user();
        }
    }
    else {
        $c->stash(
            template => 'user/edit.tt',
            form => $form
        );
    }
}

=head2 create
Create a user
=cut
sub create : PathPart( 'user/create' ) Chained( '/auth/need_role_admin' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $form = Curs::App::Form::User->new;
    my $user = $c->model('DB::User')->new_result( {} );
 
    my $proc_form;
    eval { $proc_form = $form->process( item => $user, params => $c->req->params ) };
    if ( $proc_form ) {
        $c->flash( message => 'Usuario creado' );
        $c->res->redirect( $c->uri_for('/users') );
    }
    else {
        if ( $@ ) {
            $form->field('email')->add_error( 'Error al guardar el form');
        }
        $c->stash(
            template => 'user/create.tt',
            form => $form
        );
    }
}
 
=head2 delete
Delete user
=cut
sub delete : PathPart( 'delete' ) Chained( 'element_chain_admin' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $user = $c->stash->{user};
 
    eval { $user->delete };
    if ($@) {
        $c->flash( message =>  "User can't be deleted" );
    }
    else {
        $c->flash( message => 'User has been deleted' );
    }
 
    $c->res->redirect( $c->uri_for('/users') );
}

__PACKAGE__->meta->make_immutable;

1;
