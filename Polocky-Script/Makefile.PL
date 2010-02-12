use inc::Module::Install;

name 'Polocky-Script';
author 'polocky';
all_from 'lib/Polocky/Script.pm';
requires(
    'Polocky::Core'     => 0,
    'MooseX::App::Cmd' => 0,
);

test_requires(
 'Test::Most' => 0,
 'Test::Moose' => 0,
 'Test::LoadAllModules' => 0,
);

tests('t/*.t');

license 'perl';
use_test_base;
auto_install;
WriteAll;
