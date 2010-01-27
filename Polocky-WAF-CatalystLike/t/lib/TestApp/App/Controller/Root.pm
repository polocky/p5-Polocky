package TestApp::App::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->namespace('');

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('Hello World');
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->res->body('NOT FOUND');
    $c->res->status(404);
}

sub end  :ActionClass('RenderView') { }

__POLOCKY__ ;
