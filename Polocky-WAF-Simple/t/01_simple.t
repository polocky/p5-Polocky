use strict;
use warnings;
use lib 't/lib';
use Plack::Test;
use Test::Most;
use Polocky::Test::Initializer 'App';
use TestApp::App;
use HTTP::Request;

test_psgi
    app => TestApp::App->new->psgi_handler,
    client => sub {
        my $cb = shift;

        {
            my $req = HTTP::Request->new(GET => "http://localhost/");
            my $res = $cb->($req);
            like $res->content, qr/Hello TestApp::App/ ,'body';
            is($res->code,200,'code');
        }


    };

done_testing();
