use inc::Module::Install;

name 'Polocky-WAF-CatalystLike-Controller-Mixin-ViewDetector';
author 'polocky';
all_from 'lib/Polocky/WAF/CatalystLike/Controller/Mixin/ViewDetector.pm';
requires(
    'Polocky::WAF::CatalystLike' => 0,
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
