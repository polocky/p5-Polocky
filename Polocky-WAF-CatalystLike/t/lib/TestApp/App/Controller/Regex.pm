package TestApp::App::Controller::Regex;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

sub num_num : LocalRegex('^(\d+)/(\d+)$') {
    my ( $self , $c ) = @_;
    my $id  = $c->req->captures->[0];
    my $id2 = $c->req->captures->[1];
    $c->res->body('regex:'.$id.':'.$id2);
}

sub evil : Regex('^evil/(\d+)$') {
    my ( $self , $c ) = @_;
    my $id  = $c->req->captures->[0];
    $c->res->body('regex:evil:'.$id);
}

__POLOCKY__ ;
