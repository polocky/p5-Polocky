use strict;
use warnings;
use Test::Most;
use Polocky::Test::Initializer('XXX');
use TestApp::App;

my $app = TestApp::App->new();
is(ref $app,'TestApp::App');
my $c = $app->context;
#is(ref $app->context , 'Polocky::WAF::CatalystLike::Context'); # after apply roke, ref will be differ...
is(ref $app->dispatcher, 'Polocky::WAF::CatalystLike::Dispatcher');
is(ref $app->engine , 'Polocky::WAF::CatalystLike::Engine');
is(ref $app->components, 'HASH');

done_testing();
