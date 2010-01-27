package TestApp::App::Controller::Auto;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub auto : Private {
    my ( $self , $c ) = @_;
    $c->stash->{hook} = 'auto';
}

sub test : Local {
    my ( $self , $c ) = @_;
    $c->res->body( $c->stash->{hook} . ':test' );
}

__POLOCKY__ ;
