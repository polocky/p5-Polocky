package TestApp::App::Controller::View;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };


sub test : Local {
    my ( $self , $c ) = @_;
    $c->stash->{test} = 'test';
}

__POLOCKY__ ;
