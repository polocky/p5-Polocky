use warnings;
use strict;
use lib 't/lib';
use Test::Most;
use Polocky::Test::Initializer 'View';
use TestApp::FileGenerator;
use App::Cmd::Tester;
use Polocky::Utils;
is_deeply(
[
    'App::Cmd::Command::commands',
    'App::Cmd::Command::help',
    'TestApp::FileGenerator::names',
],
[sort(TestApp::FileGenerator->command_plugins)]);
my $structure = Polocky::Utils::structure();
my $name_out_file = $structure->path_to('view/share/common/file/names.inc');
my $result = test_app('TestApp::FileGenerator', [ qw(names) ]);
is($result->stderr,"wrote file:" . $name_out_file , 'out info');
is($result->error, undef, 'threw no exceptions');

#XXX
$name_out_file = $structure->path_to('view/share/common/file/names.inc');

my @names =$name_out_file->slurp(chomp => 1);

is_deeply(
        [
        'polocky',
        'oklahomer',
        'cubtan'
        ]
        , [@names],'out file ok');

$name_out_file->remove();

done_testing();
