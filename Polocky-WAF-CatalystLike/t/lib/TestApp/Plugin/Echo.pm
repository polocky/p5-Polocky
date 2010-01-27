package TestApp::Plugin::Echo;
use Polocky::Role;

after  'SETUP' => sub {};
after  'PREPARE' => sub {
    my $c = shift;
    $c->stash->{echo} ='Kinniku Man';
};
before 'FINALIZE' => sub {};

sub echo {
    my $c = shift;   
    return $c->stash->{echo};
}


1;
