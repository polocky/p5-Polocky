use warnings;
use strict;
use Test::Most q/no_plan/;
use Polocky::Test::Initializer 'Response';
use Polocky::WAF::Request;
use Encode;
use URI::Escape;
use utf8;

{
    my $req = Polocky::WAF::Request->new({});
    is(ref $req->new_response ,'Polocky::WAF::Response');
}

{
    my $req = Polocky::WAF::Request->new({});
    is( $req->args , $req->arguments );
}

{
    my $req 
        = Polocky::WAF::Request->new({ 
            REQUEST_METHOD => 'GET',
            HTTP_HOST => 'localhost',
            REQUEST_URI => '/',
            QUERY_STRING => 'foo=%E6%97%A5%E6%9C%AC%E8%AA%9E&bar=%E6%97%A5%E6%9C%AC%E8%AA%9E&bar=%E6%97%A5%E6%9C%AC%E8%AA%9E'
        });

    is($req->param('foo'),'日本語', 'utf8 flg on');
    my @bar = $req->param('bar');
    is_deeply(\@bar,['日本語','日本語'], 'array utf8 flg on');

    {
        my $url = $req->uri_build( ['hoge' ,'はげ'],{ hoge => 'hoge' , hage => 'はげ' } );
        is( $url , 'http://localhost/hoge/%E3%81%AF%E3%81%92/?hage=%E3%81%AF%E3%81%92&hoge=hoge' );
    }
    {
        my $url = $req->uri_build( '/hoge/hoge/',{ hoge => 'hoge' , hage => 'はげ' } );
        is( $url , 'http://localhost/hoge/hoge/?hage=%E3%81%AF%E3%81%92&hoge=hoge' );
    }
    {
        my $url = $req->uri_build( '/',{ hoge => 'hoge' , hage => 'はげ' } );
        is( $url , 'http://localhost/?hage=%E3%81%AF%E3%81%92&hoge=hoge' );
    }

}
