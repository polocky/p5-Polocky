package Polocky::Config::Validator;

use strict;
use warnings;
use Kwalify;

sub validate_config {
    my ( $class, $config, $schema ) = @_;
    eval { Kwalify::validate( $schema, $config ) } ;
    if ( $@ ) {
        die "config validation error : $@" ;
    }
    1;
}

1;
