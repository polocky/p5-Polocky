use inc::Module::Install;

name 'Polocky-WAF-CatalystLike';
author 'polocky';
all_from 'lib/Polocky/WAF/CatalystLike.pm';
requires(
    'Polocky::WAF' =>0,
    'Tree::Simple' => 0,
    'Text::SimpleTable'=>0,
    'namespace::clean' =>0,
    'MooseX::MethodAttributes' =>0,
    'MooseX::Types::Moose' => 0,
    'String::RewritePrefix' => 0,
    'List::Util' => 0,
    'Module::Pluggable::Object' => 0,
    'MooseX::AttributeHelpers' => 0,
    'MRO::Compat' => 0,
    'Data::Visitor::Callback' => 0,
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
