use Test::Most qw/no_plan/;
use Polocky::Test::Initializer 'View';
use Polocky::WAF::View::JSON;
use Polocky::WAF::Context;
use Polocky::WAF::Request;
use Polocky::WAF::Response;
use utf8;

my $view = Polocky::WAF::View::JSON->new( storage_key => 'lol');
ok(ref $view , 'Polocky::WAF::View::JSON' );
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

$c->stash->{lol} = { test => 1, hoge => '日本語' };
$view->render($c);

my @content_type = $c->res->content_type;
is( $content_type[0] , "application/json" );
is( $content_type[1] , "charset=utf-8" );
is( $c->res->body , '{"test":1,"hoge":"日本語"}');
is( $c->res->status , 200 );

