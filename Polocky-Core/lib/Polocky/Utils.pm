package Polocky::Utils;

use warnings;
use strict;
use Polocky::Registrar;

sub class2prefix {
    my $class = shift || '';
    my $case  = shift || 0;
    my $prefix;
    if ( $class =~ /^.+?::(View|Controller)::(.+)$/ ) {
        $prefix = $case ? $2 : lc $2;
        $prefix =~ s{::}{/}g;
    }
    return $prefix;
}
sub class2env { 
    my $class = shift || '';
    $class =~ s/::/_/g;
    return uc($class);
}

sub env_value {
    my ( $class, $key ) = @_;

    $key = uc($key); 
    my @prefixes = ( class2env($class), 'POLOCKY' );

    for my $prefix (@prefixes) {
        if ( defined( my $value = $ENV{"${prefix}_${key}"} ) ) {
            return $value;
        }
    }
    return;
}

# steal from Catalyst
sub class2appclass {
    my $class = shift || '';
    my $appname = '';
    if ( $class =~ /^(.+?)::(View|Controller)::.+$/ ) {
        $appname = $1;
    }
    return $appname;
}
sub class2classsuffix {
    my $class = shift || '';
    my $prefix = class2appclass($class) || '';
    $class =~ s/$prefix\:://;
    if( $class =~ /^(View|Controller)::/ ) {
        return $class;
    }
    else {
        return ;
    }
}

sub appprefix {
    my $class = shift;
    $class =~ s/::/_/g;
    $class = lc($class);
    return $class;
}

sub app_name {
   return &appprefix( &app_class);
}
sub app_sub_name {
   return &appprefix( &app_sub_class);
}

sub app_class {
    return Polocky::Registrar->app_class;
}
sub app_sub_class {
    return Polocky::Registrar->app_sub_class;
}

sub init_registrar {
    Polocky::Registrar->init( shift );
}

sub  logger {
    my $class = &app_class . '::Logger';
    $class->instance();
}
sub config {
    my $class = &app_class .'::Config';
    $class->instance();
}
sub structure {
    my $class = &app_class . '::Structure';
    $class->instance();
}
sub home {
    &structure()->home;
}
sub path_to {
    &structure()->path_to(@_);
}
my $_term_width;
sub term_width {
    return $_term_width if $_term_width;

    my $width = eval '
        use Term::Size::Any;
        my ($columns, $rows) = Term::Size::Any::chars;
        return $columns;
    ';

    if ($@) {
        $width = $ENV{COLUMNS}
            if exists($ENV{COLUMNS})
            && $ENV{COLUMNS} =~ m/^\d+$/;
    }

    $width = 80 unless ($width && $width >= 80);
    return $_term_width = $width;
}

1;
