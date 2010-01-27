use strict;
use warnings;
use Test::Most qw/no_plan/;
use lib './t/lib';
use Polocky::Test::Initializer 'Test';
use Polocky::Utils;

# class2prefix
{
    is(Polocky::Utils::class2prefix('TestApp:::Test::Controller::MyRoot',1) , 'MyRoot' );
    is(Polocky::Utils::class2prefix('TestApp:::Test::Controller::MyRoot') , 'myroot' );
    is(Polocky::Utils::class2prefix('TestApp:::Test::Controller::MyRoot::Desu') , 'myroot/desu' );
    is(Polocky::Utils::class2prefix('TestApp::Test'), undef );
    is(Polocky::Utils::class2prefix(), undef );
}
# class2env
{
    is(Polocky::Utils::class2env('TestApp::Test') , 'TESTAPP_TEST' , 'class2env' );
    is(Polocky::Utils::class2env() , '' );
}
# env_value
{
    $ENV{TESTAPP_TEST_HOGE} = 'hoge';
    is(Polocky::Utils::env_value('TestApp::Test', 'hoge') , 'hoge' );
    $ENV{POLOCKY_FOO} = 'foo';
    is(Polocky::Utils::env_value('TestApp::Test', 'foo') , 'foo' );
}
# class2appclass 
{
    is(Polocky::Utils::class2appclass(),'');
    is(Polocky::Utils::class2appclass('TestApp::Test'),'');
    is(Polocky::Utils::class2appclass('TestApp::Test::View::Hoge'),'TestApp::Test');
    is(Polocky::Utils::class2appclass('TestApp::Test::Controller::Hoge'),'TestApp::Test');
}

# class2classsuffix 
{
    is(Polocky::Utils::class2classsuffix(),undef);
    is(Polocky::Utils::class2classsuffix('TestApp::Test'),undef);
    is(Polocky::Utils::class2classsuffix('TestApp::Test::View::Hoge'),'View::Hoge');
    is(Polocky::Utils::class2classsuffix('TestApp::Test::Controller::Hoge'),'Controller::Hoge');
}
# appprefix 
{
    is(Polocky::Utils::appprefix( 'TestApp::Test' ), 'testapp_test' );
}
# app_name 
{
    is(Polocky::Utils::app_name( 'TestApp::Test' ), 'testapp' );
}
# app_sub_name 
{
    is(Polocky::Utils::app_sub_name( 'TestApp::Test' ), 'test' );
}
# app_class 
{
    is(Polocky::Utils::app_class(), 'TestApp' );
}
# app_sub_class 
{
    is(Polocky::Utils::app_sub_class(), 'Test' );
}
# init_registrar 
{
    Polocky::Utils::init_registrar( 'TestApp::TestFixed' );
    is(Polocky::Utils::app_sub_class(), 'TestFixed' );
    Polocky::Utils::init_registrar( 'TestApp::Test' );
    is(Polocky::Utils::app_sub_class(), 'Test' );
}
# logger 
{
    is(ref Polocky::Utils::logger , 'Polocky::Logger::Dispatch' );
}
# config 
{
    is(ref Polocky::Utils::config , 'TestApp::Config' );
}
# structure 
{
    is(ref Polocky::Utils::structure , 'TestApp::Structure' );
}
# path_to 
{
    is(Polocky::Utils::path_to('conf')->relative , 't/testhome/conf' );
}
# term_width 
{
    my $term_width = Polocky::Utils::term_width();
    like( $term_width , qr/^\d+$/);
    is(Polocky::Utils::term_width() , $term_width );

}

