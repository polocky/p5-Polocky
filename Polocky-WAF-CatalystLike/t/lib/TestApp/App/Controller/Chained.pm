package TestApp::App::Controller::Chained;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub endpoint :Chained : PathPart('chained') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    $c->res->body('endpoint:' . $id );
}
sub foo : Chained('endpoint') : Args(1) {
    my ( $self, $c, $id ) = @_;
    $c->res->body($c->res->body . ':foo:' . $id );

}

__POLOCKY__ ;
