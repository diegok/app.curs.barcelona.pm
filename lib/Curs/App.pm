package Curs::App;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Unicode::Encoding

    Session
    Session::State::Cookie
    Session::Store::File

    Authentication
    Authorization::Roles
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in curs_app.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Curs::App',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    encoding    => 'UTF-8',
    'View::Web' => {
        INCLUDE_PATH => [
            __PACKAGE__->path_to( 'root', 'src' ),
            __PACKAGE__->path_to( 'root', 'lib' ),
        ],
    },
    'View::JSON' => {
        expose_stash => 'json', # defaults to everything
    },
    default_view => 'Web',
    'Plugin::Authentication' => {
        default_realm => 'users',
        realms        => {
            users => {
                credential => {
                    class          => 'Password',
                    password_field => 'password',
                    password_type  => 'self_check',
                },
                store => {
                    class      => 'DBIx::Class',
                    user_model => 'DB::User',
                    role_relation => 'roles',
                    role_field => 'name',
                    id_field   => 'email'
                }
            }
        }
    },
);

# Start the application
__PACKAGE__->setup();

=head1 NAME

Curs::App - Catalyst based application

=head1 SYNOPSIS

    script/curs_app_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Curs::App::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
