PolockyTest->runtests;

package PolockyTest;
use strict;
use warnings;
use Test::Most;
use Test::Moose;
use base qw(Polocky::Test::Class);
use Polocky::Test::Initializer 'Structure';

sub use_test : Tests {
    use_ok 'Polocky::Structure';
}
sub has_attribute_test : Tests {
   has_attribute_ok( 'Polocky::Structure' , 'home' );  
}

sub directly_use_exception : Tests {
    throws_ok { Polocky::Structure->instance(); }  
        qr/Don't use Polocky::Structure directly\. make subclass please\./ 
        , 'directly use does not support'
        ;
}

sub instance_test : Tests {
    my $obj = TestApp::Structure->instance();
    is( ref $obj, 'TestApp::Structure' , 'instanced');
}
sub home_test : Tests {
    my $structure = TestApp::Structure->instance();
    like( $structure->home , qr/\/t\/testhome$/ ) ;
}
sub path_to_test : Tests(4) {
    my $structure = TestApp::Structure->instance();
    like( $structure->home , qr/\/t\/testhome$/ ) ;
    like( $structure->path_to('www'), qr/\/t\/testhome\/www$/ ) ;
    is( ref $structure->path_to( 'conf/test.pl' ) , 'Path::Class::File' , 'path_to with file' );
    is( ref $structure->path_to( 'conf/' ) , 'Path::Class::Dir' , 'path_to with Dir' );
}

sub config_test : Tests(4) {
    my $structure = TestApp::Structure->instance();
    like( $structure->conf_dir, qr/\/t\/testhome\/conf$/ ) ;
    like( $structure->config_local_file_path , qr/\/t\/testhome\/conf\/test_local\.pl$/ ) ;
    like( $structure->config_file_path , qr/\/t\/testhome\/conf\/test\.pl$/ ) ;
    like( $structure->config_schema_file_path , qr/\/t\/testhome\/conf\/config_schema\.pl$/ ) ;
}

sub root_test : Tests {
    my $structure = TestApp::Structure->instance();
    like( $structure->template_dir , qr/\/t\/testhome\/view$/ ) ;
    like( $structure->template_dir('hoge') , qr/\/t\/testhome\/view\/hoge$/ ) ;
}
sub default : Tests {
    my $structure = TestApp::Structure->instance();
    local $ENV{POLOCKY_ENV} = '';
    like( $structure->config_file_path , qr/\/t\/testhome\/conf\/development\.pl$/ ) ;
}

1;
