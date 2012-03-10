package Curs::App::Controller::Example;
use Moose; use namespace::autoclean;
BEGIN {extends 'Catalyst::Controller'; }
use DateTime;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('Example index match!');
}

# /example/cero/...
sub cero :Local {
    my ( $self, $c, @args ) = @_;
    $c->res->body('Args: ' . join ', ', @args);
}

# /example/uno
sub uno :Local :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('Usando :Local :Args(0)');
}

# /example/dos
sub dos :Path('dos') :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body("Usando :Path('dos') :Args(0)");
}

# /example/tres
sub tres :Path('/example/tres') :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body(":Path('/example/tres') :Args(0)");
}

# /hola/mundo
sub cuatro :Path('/hola') :Args(1) {
    my ( $self, $c, $arg1 ) = @_;
    $c->res->body("Hola $arg1!");
}

sub cinco : Regex('^item(\d+)/order(\d+)$') { 
    my ( $self, $c ) = @_;
    my $item  = $c->req->captures->[0];
    my $order = $c->req->captures->[1];
    $c->res->body("(cinco) Item: $item | Order: $order");
}

sub seis : LocalRegex('^item(\d+)/order(\d+)$') { 
    my ( $self, $c ) = @_;
    my $item  = $c->req->captures->[0];
    my $order = $c->req->captures->[1];
    $c->res->body("(seis) Item: $item | Order: $order");
}

sub now :Local :Args(0) {
    my ( $self, $c ) = @_;
    $c->forward('stash_now');
    $c->detach('say_now');
}

sub stash_now :Private {
    my ( $self, $c ) = @_;
    $c->stash( now => DateTime->now );
}

sub say_now :Private {
    my ( $self, $c ) = @_;
    $c->res->body($c->stash->{now});
}

sub with_now : PathPart('example/now') Chained( '/' ) CaptureArgs( 0 ) {
    my ( $self, $c ) = @_;
    $c->forward('stash_now');
}

sub show_now : PathPart('show') Chained( 'with_now' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    $c->detach('say_now');
}

__PACKAGE__->meta->make_immutable;

1;
