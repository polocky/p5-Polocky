package TestApp::WAF::CatalystLike::Controller::Plugin::Foo;
use Polocky::Role;

after 'execute' => sub {
    my ( $orig , $self , $c ) = @_;
    $c->res->status(200);
    $c->res->body('FOOOOOO');
};

1;
