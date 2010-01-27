use warnings;
use strict;
use Test::Most;
use Polocky::WAF;
use lib './t/lib';
use TestApp::WAF;
throws_ok{  Polocky::WAF->new() } 'Polocky::Exception::AbstractMethod';

{
    my $waf = TestApp::WAF->new();
    throws_ok { $waf->setup_config } 'Polocky::Exception::ClassNotFound','setup_config';
    throws_ok { $waf->setup_logger } 'Polocky::Exception::ClassNotFound','setup_logger';
    throws_ok { $waf->setup_structure } 'Polocky::Exception::ClassNotFound','setup_structure';

}

{

    $ENV{POLOCKY_ENV}  = 'test';
    $ENV{POLOCKY_HOME} = './t/testhome' ;
    Polocky::Registrar->init( 'TestApp2::WAF'  );
    require TestApp2::WAF;
    my $waf = TestApp2::WAF->new();
    $waf->setup_structure;
    $waf->setup_config;
    $waf->setup_logger;
    is(ref $waf->structure,'TestApp2::Structure','structure');
    is(ref $waf->config,'TestApp2::Config','config');
    is(ref $waf->logger,'Polocky::Logger::Dispatch','logger');

}

done_testing();

