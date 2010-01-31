package TestApp::App;
use Polocky::Class;
use Polocky::Util::Initializer 'TestApp::App';
extends 'Polocky::WAF::Simple';

sub handle_request {
  my ( $self , $c ) = @_;
  $c->res->body('Hello TestApp::App');
  $c->res->content_type('text/html');
  $c->res->code( 200 );
}
__POLOCKY__;
