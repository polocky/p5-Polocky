use Test::Most qw/no_plan/;
use strict;
use warnings;
use Test::Most;
use Polocky::Test::Initializer 'Config';
use_ok 'Polocky::Config';
throws_ok { Polocky::Config->instance(); } 'Polocky::Exception';
my $config = TestApp::Config->instance();
is( ref $config ,'TestApp::Config' , 'ref of TestApp::Config' );
is( $config->logger()->{dispatchers}[0] , 'screen' );

is_deeply($config->plugin('AAA') ,{ A => 1 } );
is_deeply($config->middlewares, []);
Polocky::Utils::init_registrar( 'TestApp::Mid' );
is_deeply($config->middlewares, ['Foo','Bar']);
is($config->pkg('D'), undef );
Polocky::Utils::init_registrar( 'TestApp::Config' );
is($config->pkg('A'), 'AAA' );
is($config->pkg('B'), 'DDD' );
is($config->pkg('C'), undef );

is( $config->_get('') ,undef );
is( $config->_get('Z') ,'ZZZ' );
is( $config->_get('Y','A') ,'AAA' );

is( $config->get_internal('NEVER_FOUND') ,undef, 'not found section even in default');
is( $config->get_internal('pkg','A') ,'AAA', 'found in var in default');
is( $config->get_internal('pk','X') ,undef, 'not found in var even in default');
is( $config->get_internal('pkg','X') ,undef, 'not found in var even in default');


is( ref $config->get_internal('only_default' ) , 'HASH' , 'found var in default');
is( $config->get_internal('logger','DDDD' ) , undef );


__END__
