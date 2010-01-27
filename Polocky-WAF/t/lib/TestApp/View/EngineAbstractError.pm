package TestApp::View::EngineAbstractError;
use Polocky::Class;
extends 'Polocky::WAF::View';

sub _render {
    my ( $self, $c ) = @_;
    $self->engine;
}

__POLOCKY__ ;
