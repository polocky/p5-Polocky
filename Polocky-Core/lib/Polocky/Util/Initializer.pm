package Polocky::Util::Initializer;
use strict;
use warnings;
use UNIVERSAL::require;
use Polocky::Utils;
use Polocky::Registrar;
use Polocky::Exceptions;

sub import {
    my ($class, $app_class , $env , $home ) = @_;
    Polocky::Exception::ParameterMissingError->throw() unless $app_class;
    $ENV{POLOCKY_ENV}  =  $env if  $env ;
    $ENV{POLOCKY_HOME} = $home if $home;
    Polocky::Registrar->init( $app_class );
    for(qw(Structure Config Logger) ) {
        my $pkg = Polocky::Utils::app_class . '::' . $_;
        $pkg->require() or Polocky::Exception::ClassNotFound->throw($@ );
        $pkg->instance();
    }
}

1;
