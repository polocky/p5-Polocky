package Polocky::WAF::CatalystLike::Engine;
use Polocky::Class;
use Polocky::WAF::CatalystLike::Component::Loader;
extends 'Polocky::WAF::Engine';

has 'component_manager' => (
    is      => 'rw',
    lazy    => 1,
    builder => '_builder_component_manager',
);

sub _builder_component_manager { Polocky::WAF::CatalystLike::Component::Loader->new; }

sub handle_request {
    my $self = shift;
    my $c    = shift;
    $c->res->status( -1 );
    $c->PREPARE;
    $c->DISPATCH();
    $c->FINALIZE();
    return $c->res->status;
}

__POLOCKY__

__END__

