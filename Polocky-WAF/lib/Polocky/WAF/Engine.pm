package Polocky::WAF::Engine;
use Polocky::Class;
extends 'Polocky::Core';
use PlackX::Engine;
use Polocky::Exceptions;

has 'engine' => (
    is      => 'rw',
    isa     => 'PlackX::Engine',
    handles => [qw(psgi_handler)],
);
has 'context' => (
    is      => 'rw',
    isa     => 'Polocky::WAF::Context',
);

has 'request_handler' => (
    is  => 'rw',
    isa => 'CodeRef',
    lazy_build => 1,
);
has 'app' => ( is => 'rw', );

has 'request_class' =>(
    is      => 'rw',
    lazy_build => 1,
);

sub _build_request_class {
    my $self = shift;
    my $request = $self->config->get_internal('request_class') || 'Polocky::WAF::Request';
}

sub BUILD {
    my $self = shift;
    $self->engine( $self->build_engine );
}

sub build_engine {
    my $self = shift;
    my $engine = PlackX::Engine->new(
        {   
            request_handler => $self->request_handler,
            request_class   => $self->request_class,
            middlewares => $self->config->middlewares,
        }
    );
    return $engine;
}

sub _build_request_handler {
    my $self = shift;
    my $request_handler_with_context = sub {
        my $req = shift;
        my $c = $self->prepare_context( $req );
        $self->handle_request( $c );
        $c->res;
    };
    $request_handler_with_context;
}

# XXX have to be prefork 
sub prepare_context {
    my $self = shift;
    my $req  = shift;
    my $c = $self->context();
    $c->req( $req );
    $c->res( $req->new_response );
    return $c;
}

sub handle_request {
    my $self = shift;
    my $c    = shift;
    Polocky::Exception::AbstractMethod->throw('handle_request is abstract method');
}

__POLOCKY__

__END__
