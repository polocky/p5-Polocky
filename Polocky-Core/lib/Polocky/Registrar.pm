package Polocky::Registrar;
use strict;
our $APP_CLASS;
our $APP_SUB_CLASS;
sub app_class {
    my $class = shift;
    $Polocky::Registrar::APP_CLASS->{$class->key};
}

sub app_sub_class {
    my $class = shift;
    $Polocky::Registrar::APP_SUB_CLASS->{$class->key};
}

sub init {
    my $class = shift;
    my $name  = shift;
    my ( $app_name , $sub ) = $name=~ m/^([a-zA-Z0-9]+)::([a-zA-Z0-9]+)/;
    $Polocky::Registrar::APP_CLASS->{$class->key} = $app_name;
    $Polocky::Registrar::APP_SUB_CLASS->{$class->key} = $sub ;
}

sub key { $ENV{POLOCKY_SERVER_ID} || '_ROCK_'; }

1;
