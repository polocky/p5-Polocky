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
            my $req = HTTP::Request->new(GET => "http://localhost/view/test/");
            my $res = $cb->($req);
            like $res->content, qr/Hello World test/ ,'view test';
            is($res->code,200,'view access code');
            my @content_type = $res->content_type;
            is($content_type[0],'text/html');
            is($content_type[1],'charset=utf-8');
        }

    };

done_testing();
