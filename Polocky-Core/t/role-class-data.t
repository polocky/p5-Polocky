use Test::Most qw/no_plan/;
use lib 't/lib';
use TestCore::ClassData;
my $obj = TestCore::ClassData->new();
throws_ok { $obj->err01() } 'Polocky::Exception::NotAcceptable' ;
is($obj->a, 'A' );
is($obj->b, 'hehe' );
