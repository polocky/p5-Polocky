package Polocky::Test::Initializer;
use strict;
use warnings;
use UNIVERSAL::require;
use Polocky::Utils;
use Polocky::Registrar;
use lib './t/lib';

sub import {
    my ($class ,$sub ) = @_;
    $ENV{POLOCKY_ENV}  = 'test';
    $ENV{POLOCKY_HOME} = './t/testhome' ;
    Polocky::Registrar->init( 'TestApp::' . $sub  );
    for(qw(Structure Config Logger) ) {
        $class->generate($_); 
        my $pkg = Polocky::Utils::app_class . '::' . $_;
        $pkg->instance();
    }
}

sub generate {
    my $class = shift;
    my $name = shift;
    eval <<"";
    package TestApp::$name;
    use base qw/Polocky\::$name/;

}

1;
