use Test::Most qw/no_plan/;
use lib './t/lib';
use Polocky::Test::Initializer 'Config';
use TestCore::Core;
my $obj = TestCore::Core->new();

ok( $obj->can('load_plugin') , 'Pluggable');
ok( $obj->can('lol') , 'ClassData');
ok( $obj->can('config') ,'Configurable' );
ok( $obj->can('logger') ,'Logger');

