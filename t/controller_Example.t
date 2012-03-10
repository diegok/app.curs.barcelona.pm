use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curs::App';
use Curs::App::Controller::Example;

ok( request('/example')->is_success, 'Request should succeed' );
done_testing();
