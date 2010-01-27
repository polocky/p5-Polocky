use inc::Module::Install;

name 'Polocky-WAF-Simple';
author 'polocky';
all_from 'lib/Polocky/WAF/Simple.pm';
requires(
    'Polocky::WAF' => 0,
);
test_requires(
 'Test::Most' => 0,
 'Test::Moose' => 0,
 'Test::LoadAllModules' => 0,
 'Test::Class' => 0,
);

tests('t/*.t');

license 'perl';
use_test_base;
auto_install;
WriteAll;
