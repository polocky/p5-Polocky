package TestApp::Engine;
use Polocky::Class;
extends 'Polocky::WAF::Engine';

sub handle_request {
    my $self = shift;
    my $c    = shift;
    $c->stash->{a} = 'A';
    $c->res->code(200);
}


__POLOCKY__ ;
