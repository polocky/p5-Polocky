package Polocky::WAF::CatalystLike::Action::RenderView;
use Polocky::Class;
use Polocky::Exceptions;
extends 'Polocky::WAF::CatalystLike::Action';

sub execute {
    my $self = shift;
    my ($controller, $c ) = @_;

    return 1 if $c->req->method eq 'HEAD';

    if ($c->res->code == -1) {
        if (defined $c->res->body && length( $c->res->body ) ) {
            $c->res->code(200);
            return 1 ;
        }
    }
    else {
        return 1;
    }

    return 1 if defined $c->res->body && length( $c->res->body );

    if (scalar @{ $c->error } && !$c->stash->{template}) {
        $c->res->code(500);
        return 1 ;
    }

    $c->res->code(200);
    my $view = $c->view() 
        || Polocky::Exception::ClassNotFound->throw("Polocky::WAF::CatalystLike::Action::RenderView could not find a view to forward to.");
    $view->render($c);

    # XXX obj support
    #$c->forward( $view );
};


__POLOCKY__ ;
