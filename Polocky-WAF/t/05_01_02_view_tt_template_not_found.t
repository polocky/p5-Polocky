use Test::Most qw/no_plan/;
use Polocky::Test::Initializer 'View';
use Polocky::WAF::View::TT;
use Polocky::WAF::Context;
use Polocky::WAF::Request;
use Polocky::WAF::Response;
use Test::Output;

my $view = Polocky::WAF::View::TT->new();
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
    REQUEST_URI       => '/',
    'psgi.version'    => [ 1, 0 ],
    'psgi.input'      => undef,
    'psgi.errors'     => undef,
    'psgi.url_scheme' => 'http',
}
) );

$c->res->content_type('text/html');
$c->stash->{template} = 'view/not_found.tt';
stderr_is { $view->render($c) } "Couldn't render template view/not_found.tt: file error - view/not_found.tt: not found" , 'error log';
is( $c->res->status , 500 , 'status');
is( $c->res->body(), "render error" ,'body');
