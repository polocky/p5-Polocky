package TestApp::App::Controller::Auto::Child;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub foo : Local {
    my ( $self , $c ) = @_;
    $c->res->body( $c->stash->{hook} . ':child:foo' );
}

__POLOCKY__ ;
