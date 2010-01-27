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
            my $req = HTTP::Request->new(GET => "http://localhost/auto/test/");
            my $res = $cb->($req);
            like $res->content, qr/auto:test/ ,'auto with same pkg';
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/auto/child/foo/");
            my $res = $cb->($req);
            like $res->content, qr/auto:child:foo/ ,'auto with child pkg';
        }


    };

done_testing();
