use strict;
use warnings;

use PerlRest::App;

my $app = PerlRest::App->apply_default_middlewares(PerlRest::App->psgi_app);
$app;

