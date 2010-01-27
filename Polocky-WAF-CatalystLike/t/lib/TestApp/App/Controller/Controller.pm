package TestApp::App::Controller::Controller;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
__PACKAGE__->load_controller_mixins([qw/~Echo/]);

sub plugin : Local : Plugin('~Foo'){ }

sub mixin : Local {
    my ($self, $c) = @_;
    $c->res->body( $c->forward('hi') );
}


__POLOCKY__ ;
