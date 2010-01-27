use Test::Most qw/no_plan/;
use lib './t/lib';
require Polocky::Util::Initializer ;
use Polocky::Utils;


# ERROR
{
    throws_ok {  Polocky::Util::Initializer->import( 'LOL::Cat' ) }  'Polocky::Exception::ClassNotFound'  ;
    throws_ok {  Polocky::Util::Initializer->import() }  'Polocky::Exception::ParameterMissingError'  ;
}

# USE ENV
{
    BEGIN{
        $ENV{POLOCKY_HOME}  = './t/testhome';
        $ENV{POLOCKY_ENV}  = 'lol';
    }
    Polocky::Util::Initializer->import( 'TestApp::A' );
    is(Polocky::Utils::app_class , 'TestApp');
    is(Polocky::Utils::app_sub_class , 'A');

}

# USE PARAM 
{
    Polocky::Util::Initializer->import( 'TestApp::B' , './t/testhome' , 'development' );
    is(Polocky::Utils::app_class , 'TestApp');
    is(Polocky::Utils::app_sub_class , 'B');

}
1;
