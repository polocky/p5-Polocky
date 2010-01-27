package TestApp::Context;
use Polocky::Class;
use TestApp::Action;
extends 'Polocky::WAF::Context';

sub action {
    my $c = shift;
    return TestApp::Action->new($c);
}

__POLOCKY__ ;
