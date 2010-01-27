package Polocky::WAF::Simple::Context;
use Polocky::Class;
extends 'Polocky::WAF::Context';

has handler => ( is => 'rw');

sub DISPATCH {
    my $c = shift;
    $c->handler->($c);
}

__POLOCKY__ ;
