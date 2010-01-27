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
            my $req = HTTP::Request->new(GET => "http://localhost/regex/1/2/");
            my $res = $cb->($req);
            like $res->content, qr/regex:1:2/ ,'local regex';
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/evil/2/");
            my $res = $cb->($req);
            like $res->content, qr/regex:evil:2/ ,'regex';
        }

    };

done_testing();
