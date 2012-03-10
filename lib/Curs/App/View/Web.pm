package Curs::App::View::Web;
use Moose;
extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    CATALYST_VAR       => 'c',
    TIMER              => 0,
    ENCODING           => 'utf-8',
    WRAPPER            => 'layout',
    render_die         => 1,
);

=head1 NAME

Curs::App::View::Web - TT View for Curs::App

=head1 DESCRIPTION

TT View for Curs::App.

=head1 SEE ALSO

L<Curs::App>

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
