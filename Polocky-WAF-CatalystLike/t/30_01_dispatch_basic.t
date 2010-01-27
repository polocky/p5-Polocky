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
            my $req = HTTP::Request->new(GET => "http://localhost/");
            my $res = $cb->($req);
            like $res->content, qr/Hello World/ ,'index access test';
            is($res->code,200,'index access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost");
            my $res = $cb->($req);
            like $res->content, qr/Hello World/ ,'index access without / end test';
            is($res->code,200,'index access without / end code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/never_found_this_url/");
            my $res = $cb->($req);
            like $res->content, qr/NOT FOUND/ ,'default access test';
            is($res->code,404,'default access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/");
            my $res = $cb->($req);
            like $res->content, qr/Hello Base/ ,'base index access test';
            is($res->code,200,'base index access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base");
            my $res = $cb->($req);
            like $res->content, qr/Hello Base/ ,'base index withdout / end access test';
            is($res->code,200,'base index without / end access code');
        }


        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/never_found_this_url/");
            my $res = $cb->($req);
            like $res->content, qr/NOT BASE FOUND/ ,'base default access test';
            is($res->code,404,'bse default access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/foo/");
            my $res = $cb->($req);
            like $res->content, qr/Base:Foo/ ,'base foo access test';
            is($res->code,200,'base foo access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/foo");
            my $res = $cb->($req);
            like $res->content, qr/Base:Foo/ ,'base foo without / end access test';
            is($res->code,200,'base foo without / end access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/private_method/");
            my $res = $cb->($req);
            like $res->content, qr/NOT BASE FOUND/ ,'base private access test';
            is($res->code,404,'base private access code');
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/base/boo/");
            my $res = $cb->($req);
            like $res->content, qr/Base:private_method/ ,'detach test';
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/path/local/");
            my $res = $cb->($req);
            like $res->content, qr/path:foo:local/ ,'path test';
        }

        {
            my $req = HTTP::Request->new(GET => "http://localhost/evilpath/");
            my $res = $cb->($req);
            like $res->content, qr/path:evil:evilpath/ ,'evil path test';
        }


    };

done_testing();
