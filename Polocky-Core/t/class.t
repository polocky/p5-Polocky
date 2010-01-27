PolockyTest->runtests;
package PolockyTest;
use strict;
use warnings;
use lib 't/lib';
use TestCore::Class;
use Test::Most;
use Test::Moose ;
use Encode;
use base qw(Polocky::Test::Class);

sub use_test : Tests {
    meta_ok 'TestCore::Class' , 'meta ok';
    my $obj = TestCore::Class->new();
    ok( $obj->can('__POLOCKY__') , 'has __POLOCKY__');
}

sub utf8 : Tests {
    my $obj = TestCore::Class->new();
    ok( Encode::is_utf8($obj->love) );
}

1;
