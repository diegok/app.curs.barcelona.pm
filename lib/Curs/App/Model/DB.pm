package Curs::App::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Curs::Schema',
    traits       => 'SchemaProxy',
);

=head1 NAME

Curs::App::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Curs::App> and L<Curs::Schema>.

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Curs::Perl::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.5

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;