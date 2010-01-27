use strict;
use warnings;
use Test::Most qw/no_plan/;
use Polocky::Test::Initializer 'Context';
use Polocky::WAF::Context;
use Polocky::WAF::Request;
use Polocky::Utils;
my $context = Polocky::WAF::Context->new( res => Polocky::WAF::Response->new({}) );
is($context->SETUP,1,'CALL SETUP');
is($context->PREPARE,1 , 'CALL PREPARE');
is($context->DISPATCH,1 , 'CALL DISPATCH');
is($context->FINALIZE,1 , 'CALL FINALIZE');


is_deeply($context->error(),[]);
$context->error('BINGO!');
is_deeply($context->error(),['BINGO!']);
$context->error(['YES!','YES!']);
is_deeply($context->error(),['BINGO!','YES!','YES!']);
$context->error(0);
is_deeply($context->error(),[]);


is($context->setup_plugins(),1);
Polocky::Registrar->init('TestApp::Having');
is($context->setup_plugins(),1);
is($context->bingo,'bingo');
