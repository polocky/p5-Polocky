package Polocky::WAF::Context;
use Polocky::Class;
extends 'Polocky::Core';
use Polocky::WAF::Request;

#has stash => (is => 'rw', default => sub { {} });
has req => (
    is       => 'rw',
    isa      => 'Polocky::WAF::Request',
    handles => ['session','stash'],
);

has 'res' => (
    is => 'rw',
    isa => 'Plack::Response',
    handles => ['redirect'],
);
has 'structure' => (
    is  => 'rw',
);

sub BUILD {
    my $self = shift;
    $self->setup_plugins();
}

sub SETUP { 1 } # PLUGIN HOOK DO NOT DELETE
sub PREPARE { 1 }
sub DISPATCH { 1 }
sub FINALIZE {
    my $c = shift;
    $c->res->finalize;
    $c->reset();
    1;
}

sub setup_plugins {
    my $self = shift;
    my $config = $self->config->get_internal('plugins');
    my $plugins 
        = $self->load_plugins( @{$config} ) if scalar @{$config};
    1;
}

sub error {
    my $c = shift;
    if ( $_[0] ) {
        my $error = ref $_[0] eq 'ARRAY' ? $_[0] : [@_];
        push @{ $c->{error} }, @$error;
    }
    elsif ( defined $_[0] ) { $c->{error} = undef }
    return $c->{error} || [];
}

sub reset {
    my $c = shift;
    $c->error(0);
}

__POLOCKY__;

