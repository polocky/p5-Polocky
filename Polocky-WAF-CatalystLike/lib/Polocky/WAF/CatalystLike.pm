package Polocky::WAF::CatalystLike;

our $VERSION = '0.01_01';

use Polocky::Class;
extends 'Polocky::WAF';
use Polocky::WAF::CatalystLike::Engine;
use Polocky::WAF::CatalystLike::Dispatcher;
use Polocky::WAF::CatalystLike::Context;
use Polocky::Utils;
with 'Polocky::Role::Pluggable';

has 'context' => (
    is      => 'rw',
    isa     => 'Polocky::WAF::CatalystLike::Context',
);
has 'dispatcher' => (
    is  => 'rw',
    isa => 'Polocky::WAF::CatalystLike::Dispatcher',
);
has 'engine' => (
    is => 'rw',
    handles => [qw(psgi_handler)],
);
#has 'engine_mode' => (
#    is      => 'rw',
#    default => 'daemon',
#);
has 'components' => (
    is  => 'rw',
);


sub setup {
    my $self = shift;
    $self->setup_structure; 
    $self->setup_config; 
    $self->setup_logger; 
    $self->setup_context; 
    $self->setup_engine;
    $self->setup_components;
    $self->setup_dispatcher;
    $self->context->SETUP(); # HOOK >_<
}

sub setup_components {
    my $self       = shift;
    my $components = $self->engine->component_manager->setup( Polocky::Utils::app_sub_class );
    $self->components( $components );
    $self->context->components( $components );
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

    my $c = Polocky::WAF::CatalystLike::Context->new();
    $c->structure ( $self->structure );
    return $c;
}

sub setup_dispatcher {
    my $self = shift;
    my $dispatcher = $self->create_dispatcher;
    $dispatcher->setup( $self->components );
    $self->context->dispatcher( $dispatcher );
    $self->dispatcher( $dispatcher );
}

sub create_dispatcher {
    my $self = shift;
    return Polocky::WAF::CatalystLike::Dispatcher->new();
}

sub setup_engine {
    my $self = shift;
    my $engine = Polocky::WAF::CatalystLike::Engine->new(
            root    => $self->structure->template_dir,
            context => $self->context,
            );
    $engine->app($self);
    $self->engine($engine);
    $engine;
}

__POLOCKY__

__END__

=head1 NAME

Polocky - Yet Another Framework For polocky

=head1 DESCRIPTION

=head1 NOTE

many code steal from Catalyst and Angelos

=head1 AUTHOR

polocky

=cut
