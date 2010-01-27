use warnings;
use strict;
use Test::Most q/no_plan/;
use Polocky::Test::Initializer 'Response';
use Polocky::WAF::Response;
use Encode;
use utf8;

{
    my $res = Polocky::WAF::Response->new();
    $res->content_type('text/html');
    is( $res->_body()->[0] , undef , 'text/* empty body' );
}

{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( $body );
    $res->content_type('text/html');
    is( $res->_body()->[0] , Encode::encode('utf8',$body) , 'text/* encode body' );
}

{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( [$body] );
    $res->content_type('text/html');
    is( $res->_body()->[0] , Encode::encode('utf8',$body) , 'text/* encode body with array body' );
}

{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( $body );
    $res->content_type('application/json');
    is( $res->_body()->[0] , Encode::encode('utf8',$body) , 'application/json encode body' );
}
{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( [$body] );
    $res->content_type('application/json');
    is( $res->_body()->[0] , Encode::encode('utf8',$body) , 'application/json encode body with array body' );
}

{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( $body );
    $res->content_type('application/pson');
    is( $res->_body()->[0] ,$body , 'none text body' );
}

{
    my $body = "日本語";
    my $res = Polocky::WAF::Response->new();
    $res->body( [$body] );
    $res->content_type('application/pson');
    is( $res->_body()->[0] ,$body , 'none text body with array body' );
}

{
    my $res = Polocky::WAF::Response->new();
    $res->redirect('/');
    is( $res->content_type() , 'text/html' );
}


