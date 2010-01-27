use Test::Most qw/no_plan/;
use Test::Output;
use Polocky::Test::Initializer 'View';
use Polocky::WAF::View;
use TestApp::Context;
use Polocky::WAF::Request;
use Polocky::WAF::Response;
use TestApp::View::EngineAbstractError;
use TestApp::View::Test;
my $c = TestApp::Context->new();
$c->res( Polocky::WAF::Response->new );
$c->req( Polocky::WAF::Request->new(
+{
    REQUEST_METHOD    => 'GET',
    SERVER_PROTOCOL   => 'HTTP/1.1',
    SERVER_PORT       => 80,
    SERVER_NAME       => 'example.com',
    SCRIPT_NAME       => '/foo',
    REMOTE_ADDR       => '127.0.0.1',
    REQUEST_URI       => '/A/B/C',
    'psgi.version'    => [ 1, 0 ],
    'psgi.input'      => undef,
    'psgi.errors'     => undef,
    'psgi.url_scheme' => 'http',
}
) );


# abstract method test
{
    my $view = Polocky::WAF::View->new();
    throws_ok{ $view->render($c) } 'Polocky::Exception::AbstractMethod' , '_render method must be overwrite';
}
{
    my $view = TestApp::View::EngineAbstractError->new();
    throws_ok{ $view->render($c) } 'Polocky::Exception::AbstractMethod' , '_build_engine method must be overwrite';
}

# default template , set content type 
{
    my $view = TestApp::View::Test->new();    
    is($c->res->content_type,'');
    $view->render($c); 
    my @content_type = $c->res->content_type;
    is($content_type[0],'text/html');
    is($content_type[1],'charset=utf-8');
    is($c->stash->{template},'/A/B/C.templ' , 'default templ with action mock' );
}


# default template , set content type 
{
    my $c = Polocky::WAF::Context->new();
    $c->res( Polocky::WAF::Response->new );
    $c->req( Polocky::WAF::Request->new(
                +{
                REQUEST_METHOD    => 'GET',
                SERVER_PROTOCOL   => 'HTTP/1.1',
                SERVER_PORT       => 80,
                SERVER_NAME       => 'example.com',
                SCRIPT_NAME       => '/foo',
                REMOTE_ADDR       => '127.0.0.1',
                REQUEST_URI       => '/A/B/C',
                'psgi.version'    => [ 1, 0 ],
                'psgi.input'      => undef,
                'psgi.errors'     => undef,
                'psgi.url_scheme' => 'http',
                }
    ) );
    my $view = TestApp::View::Test->new();    
    $view->render($c);
    is($c->stash->{template},undef , 'default templ without action mock' );
}


