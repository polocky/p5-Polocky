package TestApp::WAF::CatalystLike::Controller::Mixin::Echo;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub hi : Private {
    my ($self, $c) = @_;
    'HI HI HI';
}

__POLOCKY__;
