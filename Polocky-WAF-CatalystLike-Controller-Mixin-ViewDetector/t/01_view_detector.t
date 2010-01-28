use strict;
use warnings;
use lib 't/lib';
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
            {
                my $req = HTTP::Request->new(GET => "http://localhost/guide/");
                my $res = $cb->($req);
                like $res->content, qr/GUIDE INDEX/ ,'guide index';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/guide");
                my $res = $cb->($req);
                like $res->content, qr/GUIDE INDEX/ ,'guide index no / end';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/guide/howto/");
                my $res = $cb->($req);
                like $res->content, qr/HOWTO GUIDE/ ,'guide howto';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/guide/howto");
                my $res = $cb->($req);
                like $res->content, qr/HOWTO GUIDE/ ,'guide howto not / end';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/guide/notfound");
                my $res = $cb->($req);
                like $res->content, qr/NOT FOUND/ ,'guide not found';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/deep/guide/");
                my $res = $cb->($req);
                like $res->content, qr/DEEP GUIDE INDEX/ ,'deep guide index';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/deep/guide/howto/");
                my $res = $cb->($req);
                like $res->content, qr/DEEP GUIDE HOWTO/ ,'deep guide howto';
            }

            TODO: {
                todo_skip 'not implement yet', 1 ;
                my $req = HTTP::Request->new(GET => "http://localhost/deep/guide/more/");
                my $res = $cb->($req);
                like $res->content, qr/MORE DEEP INDEX/ ,'more deep index';
            }

            {
                my $req = HTTP::Request->new(GET => "http://localhost/deep/guide/more/deeper/");
                my $res = $cb->($req);
                like $res->content, qr/MORE DEEPER/ ,'more deeper';
            }


        }
    };

done_testing();
