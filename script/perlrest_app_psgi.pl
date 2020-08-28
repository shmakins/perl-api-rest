use strict;
use PerlRest::App;
 
PerlRest::App->setup_engine('PSGI');
my $app = sub { PerlRest::App->run(@_) };
