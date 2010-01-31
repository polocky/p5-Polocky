package Polocky::WAF::Simple;
use Polocky::Class;
extends 'Polocky::WAF';
use Polocky::WAF::Simple::Engine;
use Polocky::WAF::Simple::Context;

our $VERSION = '0.02';

has 'context' => (
    is      => 'rw',
    isa     => 'Polocky::WAF::Simple::Context',
);
has 'engine' => (
    is => 'rw',
    handles => [qw(psgi_handler)],
);

sub import {
    my $caller = shift;
    die "you must have [Use Polocky::Util::Initializer '$caller';] in your handler" unless ( Polocky::Utils::app_sub_class );

    #Polocky::Utils::init_registrar( $caller );
}
sub setup {
    my $self = shift;
    $self->setup_structure; # review ok
    $self->setup_config; # review ok
    $self->setup_logger; # review ok
    $self->setup_context; # later :-)
    $self->setup_handler;
    $self->setup_engine;
    $self->context->SETUP(); # HOOK >_<
}
sub setup_handler {
    my $self = shift;
    $self->context->handler( sub { $self->handle_request(@_)  } );

}

sub setup_engine {
    my $self = shift;
    my $engine = Polocky::WAF::Simple::Engine->new(
            context => $self->context,
            );
    $engine->app($self);
    $self->engine($engine);
    $engine;
}


sub setup_context {
    my $self = shift;
    my $plugins = shift;
    my $context = $self->create_context;
    $self->context($context);
    $context;
}

sub create_context {
    my $self = shift;

    my $c = Polocky::WAF::Simple::Context->new();
    $c->structure ( $self->structure );
    return $c;
}

1;

=head1 NAME

Polocky::WAF::Simple - Simple Polocky WAF

=head1 SYNOPSIS

 package TestApp::App;
 use Polocky::Class;
 use Polocky::Util::Initializer 'TestApp::App';
 extends 'Polocky::WAF::Simple';
 
 sub handle_request {
   my ( $self , $c ) = @_;
   $c->res->body('Hello TestApp::App');
   $c->res->content_type('text/html');
   $c->res->code( 200 );
 }

__POLOCKY__;

=head1 DESCRIPTION

WAF::Simple has no disptcher, so what you need to do is just write handler_request. 
This is handy when you want to write fast and simple WEB.

=head1 AUTHOR

polocky

=cut
