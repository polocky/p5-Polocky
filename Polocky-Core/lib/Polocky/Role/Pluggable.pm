package Polocky::Role::Pluggable;
use Carp ();
use Polocky::Role;
use Moose::Util;
use Polocky::Utils;
use Polocky::Exceptions;

sub load_plugin {
    my $self = shift;
    $self->load_plugins(@_);
}

sub load_plugins {
    my ( $self, @roles ) = @_;
    Polocky::Exception::ParameterMissingError->throw("You must provide a plugin name") unless @roles;
    $self->_load_and_apply_role(@roles)  ;
    return \@roles;
}

sub _load_and_apply_role {
    my ( $self, @roles ) = @_;
    eval { Moose::Util::apply_all_roles(( $self, @roles )) };
    if($@){ 
        Polocky::Exception::InvalidArgumentError->throw( $@ );
    }
    return 1;
}


1;
