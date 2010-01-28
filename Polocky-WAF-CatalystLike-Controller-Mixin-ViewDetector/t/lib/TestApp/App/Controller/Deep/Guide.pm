package TestApp::App::Controller::Deep::Guide;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->load_controller_mixins([qw/ViewDetector/]);

__POLOCKY__;
