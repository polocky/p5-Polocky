use Test::Most qw/no_plan/;
use strict;
use Polocky::Home;
use Cwd;

# cur
{
    my $cur1 = Polocky::Home->detect('MyApp');
    my $cur2 = Polocky::Home->detect();
    is($cur1,$cur2);
    is($cur1,Cwd::getcwd);
}
# env
{
    local $ENV{POLOCKY_HOME} = '/tmp';
    my $cur1 = Polocky::Home->detect('MyApp');
    is( $ENV{POLOCKY_HOME} , $cur1 );

    local $ENV{MYAPP_HOME} = '/tmp';
    my $cur2 = Polocky::Home->detect('MyApp');
    is( $ENV{MYAPP_HOME} , $cur2 );
}

# error
{

    local $ENV{MYAPP_HOME} = '/apdoifjadpfoijaopdfijadfpoijadfoijasdpfoiajp/dapsfoiajdfs/';
    my $cur = Polocky::Home->detect('MyApp');
    is( Cwd::getcwd , $cur );

}
1;
