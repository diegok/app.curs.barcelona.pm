package Curs::App::View::Web;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
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
