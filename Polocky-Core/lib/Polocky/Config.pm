package Polocky::Config;

use strict;
use warnings;
use Polocky::Config::Loader;
use Polocky::Utils;
use MooseX::Singleton;
use Polocky::Class;
use Polocky::Exceptions;

sub BUILD { 
    my $self = shift;
    Polocky::Exception->throw("Don't use Polocky::Config directly. make subclass please.") if ref $self eq 'Polocky::Config';
    $self->{config} = Polocky::Config::Loader->load( Polocky::Utils::structure );
    $self->{config_internal} = Polocky::Config::Loader->load_internal( Polocky::Utils::structure );
    return $self;
}


sub _get {
    my $self    = shift;
    my $section = shift;
    my $var     = shift;
    unless ( $self->{config}->{$section} ) {
        return;
    }
    unless ($var) {
        return $self->{config}->{$section};
    }
    return $self->{config}->{$section}->{$var};
}

sub get_internal {
    my $self    = shift;
    my $section = shift;
    my $var     = shift;
    my $sub_name = Polocky::Utils::app_sub_name ;

    my $root = $self->{config_internal}{application}{$sub_name}{$section} ;

    # from app
    if ($root) {
        unless ($var) {
            return $root;
        }
        # from app
        my $child = $root->{$var};
        if( $child ) {
            return $child;
        }
        # from default
        else {
            my $default_root = $self->{config_internal}{default}{$section} or return;
            return $default_root->{$var};
        }
    }
    # from default
    else {
        $root = $self->{config_internal}{default}{$section};
        
        return unless $root ;
        unless ($var) {
            return $root;
        }
        return $root->{$var};
    }
}

sub logger { shift->get_internal('logger') }

sub plugin { 
    my $self = shift;
    my $name = shift;
    $self->get_internal( 'plugin' , $name ); 
}

sub middlewares {
    my $self = shift;
    return $self->get_internal( 'middlewares' ) || [];
}
sub pkg {
    my $self = shift;
    my $x_class_name = shift;
    return $self->get_internal( 'pkg', $x_class_name);
}

1;

=head1 NAME

Polocky::Config  - Configクラス

=head1 DESCRIPTION

コンフィグデータにアクセスすることができます。Singleton実装されています。

=head1 SYNOPSIS

 package MyApp::Config;
 use warnings;
 use strict;
 use base qw(Polocky::Config);
 
 1;


 my $config = MyApp::Config->instance();

=head1 METHOD

=head2 instance

config objectを取得します

=head1 AUTHOR

polocky

=cut
