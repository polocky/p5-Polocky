package TestApp::App::Controller::Plugin;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub echo : Local {
    my ($self, $c) = @_;
    $c->res->body( $c->echo );
}


__POLOCKY__ ;
