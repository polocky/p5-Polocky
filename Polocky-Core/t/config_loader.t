use Test::Most qw/no_plan/;
use lib './t/lib';
use Polocky::Util::Initializer 'TestApp::Test' , 'test' ,'./t/testhome2';

my $structure = TestApp::Structure->instance();
my $config = Polocky::Config::Loader->load( $structure );
is( ref $config , 'HASH' );
like( $config->{test}{home} , qr/t\/testhome2$/ );
like( $config->{test}{conf} , qr/t\/testhome2\/conf$/ );

$config = Polocky::Config::Loader->load_internal( $structure );
is( ref $config , 'HASH' );
ok( exists $config->{application} );
ok( exists $config->{default} );
