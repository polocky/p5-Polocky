use inc::Module::Install;

name 'Polocky-WAF';
author 'polocky';
all_from 'lib/Polocky/WAF.pm';
requires(
    'Polocky::Core'     => 0,
    'Plack'             => 0,
    'Template'          => 0,
    'JSON::Syck'        => 0,
    'PlackX::Engine'    => 0,
    'MooseX::NonMoose'  => 0,
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
