use strict;
use warnings;
use Test::Most;
use Polocky::Test::Initializer 'Engine';
use Polocky::WAF::Engine;
use Polocky::WAF::Context;
use TestApp::Engine;

# default request
{
    my $engine = Polocky::WAF::Engine->new();
    is( $engine->request_class, 'Polocky::WAF::Request' );
}
# set specific request class
{
    Polocky::Registrar->init('TestApp::EngineReq'); 
    my $engine = Polocky::WAF::Engine->new();
    is( $engine->request_class, 'TestApp::Request' );
    Polocky::Registrar->init('TestApp::Engine'); 
}

{
    my $engine = Polocky::WAF::Engine->new();
    $engine->context( Polocky::WAF::Context->new );
    my $handler = $engine->psgi_handler;
    throws_ok { $handler->({ REQUEST_METHOD => 'GET' }) } 'Polocky::Exception::AbstractMethod';
}

{
    my $engine = TestApp::Engine->new();
    $engine->context( Polocky::WAF::Context->new );
    my $handler = $engine->psgi_handler;
    $handler->({ REQUEST_METHOD => 'GET' });
    is($engine->context->stash->{a} , 'A');
}

done_testing();
