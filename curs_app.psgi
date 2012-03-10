use strict;
use warnings;

use lib 'lib/';
use Curs::App;

my $app = Curs::App->apply_default_middlewares(Curs::App->psgi_app);
$app;

