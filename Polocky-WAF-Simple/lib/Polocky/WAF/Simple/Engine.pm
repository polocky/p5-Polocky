package Polocky::WAF::Simple::Engine;
use Polocky::Class;
extends 'Polocky::WAF::Engine';

sub handle_request {
    my $self = shift;
    my $c    = shift;
    $c->res->status( -1 );
    $c->PREPARE;
    $c->DISPATCH;
    $c->FINALIZE();
    return $c->res->status;
}

1;
