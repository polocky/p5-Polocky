use strict;
use warnings;
use Test::Most qw/no_plan/;
use Test::Output;
use Polocky::Test::Initializer 'Mid';

my $logger = TestApp::Logger->instance();
my $logger2 = TestApp::Logger->instance();
is( $logger , $logger2 );
stderr_is { $logger->debug('hi') } "hi" ,"debug";
stderr_is { $logger->warning('hi') } "hi" ,"warning";
stderr_is { $logger->info('hi') } "hi" ,"info";
stderr_is { $logger->critical('hi') } "hi" ,"critical";
stderr_is { $logger->notice('hi') } "hi" ,"notice";
stderr_is { $logger->error('hi') } "hi" ,"error";

Polocky::Test::Initializer->import( 'Hoge') ;
my $logger3 = TestApp::Logger->instance();
isnt( $logger, $logger3 );
my $logger4 = TestApp::Logger->instance();
is( $logger3, $logger4 );

