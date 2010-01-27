use strict;
use warnings;
use Plack::Test;
use Test::Most;
use Polocky::Test::Initializer 'XXX';
use TestApp::App;
use HTTP::Request;

test_psgi
    app => TestApp::App->new->psgi_handler,
    client => sub {
        my $cb = shift;

        {
            my $req = HTTP::Request->new(GET => "http://localhost/plugin/echo/");
            my $res = $cb->($req);
            like $res->content, qr/Kinniku Man/ ,'plugin test';
        }


    };

done_testing();

