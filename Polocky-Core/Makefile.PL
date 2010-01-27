use inc::Module::Install;

name 'Polocky-Core';
author 'polocky';
all_from 'lib/Polocky/Core.pm';
requires(
    'Moose'       =>0,
    'File::Spec'  =>0,
    'Path::Class' =>0,
    'MooseX::Singleton' => 0,
    'Term::Size::Any' => 0,
    'Log::Dispatch::Configurator' => 0,
    'Log::Dispatch::Config' => 0,
    'Kwalify' => 0,
    'UNIVERSAL::require' => 0,
    'Data::Visitor::Callback' => 0,
    'String::RewritePrefix' => 0,
    'Module::Pluggable::Object' => 0,
    'Exception::Class' => 0,
    'Storable' => 0,
    'Module::Setup' =>0.07,
);
test_requires(
 'Test::Most' => 0,
 'Test::Moose' => 0,
 'Test::LoadAllModules' => 0,
 'Module::Load::Conditional' => 0,
 'Test::Class' => 0,
 'Test::Output' => 0,
);

tests('t/*.t');
install_script glob('bin/polocky-setup');

license 'perl';
use_test_base;
auto_install;
WriteAll;
