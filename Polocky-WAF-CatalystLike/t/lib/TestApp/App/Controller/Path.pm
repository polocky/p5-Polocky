package TestApp::App::Controller::Path;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub foo : Path('local') {
    my ($self,$c) = @_;
    $c->res->body('path:foo:local');
}

sub evil : Path('/evilpath') {
    my ($self,$c) = @_;
    $c->res->body('path:evil:evilpath');
}


__POLOCKY__ ;
