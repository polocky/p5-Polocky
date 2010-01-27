use Test::Most qw/no_plan/;
use warnings;
use strict;
use Polocky::Registrar;

{
    Polocky::Registrar->init( 'TestApp::Sub' );
    is(  Polocky::Registrar->app_class , 'TestApp' );
    is(  Polocky::Registrar->app_sub_class , 'Sub' );
    is( Polocky::Registrar->key , '_ROCK_' );
}

{
    local $ENV{POLOCKY_SERVER_ID} = 2;
    Polocky::Registrar->init( 'TestApp2::Sub2' );
    is(  Polocky::Registrar->app_class , 'TestApp2' );
    is(  Polocky::Registrar->app_sub_class , 'Sub2' );
    is( Polocky::Registrar->key , '2' );
}
{
    is(  Polocky::Registrar->app_class , 'TestApp' );
    is(  Polocky::Registrar->app_sub_class , 'Sub' );
    is( Polocky::Registrar->key , '_ROCK_' );
}

{
    local $ENV{POLOCKY_SERVER_ID} = 2;
    is(  Polocky::Registrar->app_class , 'TestApp2' );
    is(  Polocky::Registrar->app_sub_class , 'Sub2' );
    is( Polocky::Registrar->key , '2' );
}

1;
