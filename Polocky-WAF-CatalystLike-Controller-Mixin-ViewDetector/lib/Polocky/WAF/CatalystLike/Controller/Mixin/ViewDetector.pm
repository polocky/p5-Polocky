package Polocky::WAF::CatalystLike::Controller::Mixin::ViewDetector;
use Polocky::Class;
use Polocky::Utils;
use Polocky::Exceptions;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

our $VERSION = '0.01';

sub default : Path {
    my ( $self, $c ) = @_;

    my $path = $c->req->action .'/';
    my $arguments = $c->req->arguments;
    if( scalar @$arguments ) {
        $path .= join('/',@$arguments);
    }
    else {
        $path .= 'index';    
    }

    # TODO ... このMixInのシステム自体がデフォルト/変更設定を行いづらいのでなんとかする必要がある。
    $path .= '.tt';


    my $abs = Polocky::Utils::structure->template_dir(Polocky::Utils::app_sub_name )->subdir( $path );

    unless(-e $abs ) {
        # XXX 決めうち
        $c->detach('/default');     
    }
    else {
        # TODO ...
        $c->res->code(200);
        $c->stash->{template} = $path;
        my $view = $c->view()  
        || Polocky::Exception::ClassNotFound->throw("Polocky::WAF::CatalystLike::Controller::Mixin::ViewDetector could not find a view to forward to.");
        $view->render($c);
    }
}

__POLOCKY__;

=head1 NAME

Polocky::WAF::CatalystLike::Controller::Mixin::ViewDetector - Viewを自動発見するコントローラです

=head1 SYNOPSIS

 package TestApp::App::Controller::Guide;
 use Polocky::Class;
 BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };
 __PACKAGE__->load_controller_mixins([qw/ViewDetector/]);

 __POLOCKY__;


 http://localhost/guide/what_ever/ map to view/app/guide/what_ever.tt 
 http://localhost/guide/what/ever/ map to view/app/guide/what/ever.tt 

=head1 DESCRIPTION

アルファクォリティです。改善するには、Controller Mixinの仕組み自体の見直しが必要です。

アクション定義行がなくても、自動でテンプレートを見つけ表示してくれます。
ガイドページ等の処理がほとんどないけど、レイアウト的にviewは使いたいみたいなケースに利用できます。

=head1 AUTHOR

polocky

=cut
