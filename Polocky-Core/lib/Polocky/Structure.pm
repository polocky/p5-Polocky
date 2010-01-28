package Polocky::Structure;

use File::Spec;
use Polocky::Home;
use Path::Class qw(dir file);
use MooseX::Singleton;
use Polocky::Utils;
use Polocky::Exceptions;

has home => ( is => 'rw');

sub BUILD {
    my $self = shift;
    Polocky::Exception->throw("Don't use Polocky::Structure directly. make subclass please.") if ref $self eq 'Polocky::Structure';
    my $home = Polocky::Home->detect(  Polocky::Utils::app_class );
    $self->home( $home );
    return $self;
}

sub conf_dir { shift->path_to('conf')   }
sub template_dir { 
    my $self = shift;
    $self->path_to( 'view' , shift ) ;
}

sub path_to {
    my ( $self, @path ) = @_;
    my $path = File::Spec->catfile( $self->{home}, @path );
    if ( -f $path ) {
        return file( $self->{home}, @path );
    }
    else {
        return dir( $self->{home}, @path );
    }
}

sub config_global_file_path {
    my $self = shift;
    file( $self->conf_dir, 'global.pl' );
}

sub config_file_path {
    my $self = shift;
    file( $self->conf_dir, $self->_environment . '.pl' );
}

sub config_local_file_path {
    my $self = shift;
    my $extension = '.pl';
    my $config_filename = $self->_environment . '_local' . $extension;
    file( $self->conf_dir, $config_filename );
}

sub config_schema_file_path {
    my $self = shift;
    file( $self->conf_dir, 'config_schema.pl' );
}

sub config_internal_file_path {
    my $self = shift;
    file( $self->conf_dir, $self->_environment . '_internal.pl' );
}

sub config_internal_local_file_path {
    my $self = shift;
    my $extension = '.pl';
    my $config_filename = $self->_environment . '_internal_local' . $extension;
    file( $self->conf_dir, $config_filename );
}

sub config_internal_schema_file_path {
    my $self = shift;
    file( $self->conf_dir, 'config_internal_schema.pl' );
}

sub _environment {
    my $self = shift;
    my $environment;
    $environment = $ENV{POLOCKY_ENV} ;
    $environment = 'development' unless $environment;
    $environment;
}

1;

=head1 NAME

Polocky::Structure - ポロキィの構造

=head1 DESCRIPTION

アプリケーションの構造を保持するクラスです。
アプリケーション毎に、このクラスを継承したクラスを用意する必要があります。

=head1 DEPENDENCY

このクラスを利用する前にアプリケーション名及び、HOME ディレクトリを解決しておく必要があります。

=head1 SYNOPSIS

 package MyApp::Structure;

 use warnings;
 use strict;
 use base qw(Polocky::Structure);

 1;

 use MyApp::Structure;

 my $structure = MyApp::Structure->instance();
 my $conf_dir  = $structure->conf_dir();

=head1 METHOD

=head2 home

ホームルートを取得します。 SEE ALSO L<Polocy::Home>

=head2 path_to(@args)

パスを取得することができます。

 $structure->path_to( 'view' ,'common');

=head2 conf_dir

コンフィグファイルを保管しているディレクトリを取得することができます。

=head2 template_dir

ルートディレクトリを取得することができます。 XXX

=head2 BUILD

初期化処理

=head2 config_file_path

コンフィグファイルのパス

=head2 config_global_file_path

グローバルコンフィグファイルのパス

=head2 config_internal_file_path

内部コンフィグファイルのパス

=head2 config_internal_local_file_path

内部ローカルコンフィグファイルのパス

=head2 config_internal_schema_file_path

コンフィグツリーのヴァリデーションルールの記載したファイル

=head2 config_local_file_path

ローカルコンフィグのファイルのパス

=head2 config_schema_file_path

コンフィグツリーのヴァリデーションルールの記載したファイル

=head1 SEE ALSO

L<File::Spec>
L<Polocky::Home>
L<Path::Class>

=head1 AUTHOR

polocky

=cut
