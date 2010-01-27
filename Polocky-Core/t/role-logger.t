use Test::Most qw/no_plan/;
use Polocky::Test::Initializer 'RoleTest';
use TestCore::RoleLogger;
my $obj = TestCore::RoleLogger->new();
is(ref $obj->logger , 'Polocky::Logger::Dispatch' );
