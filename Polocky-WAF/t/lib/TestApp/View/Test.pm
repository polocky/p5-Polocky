package TestApp::View::Test;
use Polocky::Class;
extends 'Polocky::WAF::View';

sub _render {
    my ( $self, $c ) = @_;
    $self->engine;
}

sub _build_engine {
    my $self = shift;
  
}


__POLOCKY__ ;
