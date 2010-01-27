package TestApp::App::Controller::Base;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body('Hello Base');
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->res->body('NOT BASE FOUND');
    $c->res->status(404);
}

sub foo : Local {
    my ( $self, $c ) = @_;
    $c->res->body('Base:Foo');
}
sub private_method : Private {
    my ( $self, $c ) = @_;
    $c->res->body('Base:private_method');
}

sub bar : Local {
    my ( $self, $c ) = @_;
    $c->forward('private_method');
    $c->res->body( $c->res->body . ':bar' );
}

sub boo : Local {
    my ( $self, $c ) = @_;
    $c->detach('private_method');
    $c->res->body( $c->res->body . ':boo' );
}
__POLOCKY__ ;
