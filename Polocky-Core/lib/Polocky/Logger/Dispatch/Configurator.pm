package Polocky::Logger::Dispatch::Configurator;
use base 'Log::Dispatch::Configurator';
use strict;
use warnings;

sub new {
    my($class, $config) = @_;
    my $self = bless { _config => $config }, $class;
    return $self;
}

sub get_attrs_global {
    my $self = shift;
    my $dispatchers = $self->{'_config'}->{'dispatchers'} ;
    return {
        format => undef,
        dispatchers => $dispatchers,
    };
}

sub get_attrs {
      my($self, $name) = @_;
      return $self->{'_config'}->{$name};
}

1;

# Idiot.
