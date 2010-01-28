package Polocky::Class;
use Moose;
use Moose::Exporter;
use utf8;

Moose::Exporter->setup_import_methods(
    also => ['Moose'],
    with_caller => ['__POLOCKY__'],
);

sub init_meta { utf8->import() }

sub __POLOCKY__ {
    my ( $caller, ) = @_;
    Moose::unimport;
    $caller->meta->make_immutable( inline_destructor => 1 );
    'Love Polocky';
}
1;

=head1 NAME

Polocky::Class - Subclass of Moose 

=head1 SYNOPSIS

 package MyModule;
 
 use Polocky::Class;

 has 'my_method' => (
    is => 'rw'
 );

 __POLOCKY__;
 
=head1 DESCRIPTION

Polocky システムのほとんどのクラスのベースになるクラスです。
L<Moose>のサブクラスなのですが、 利用の際に__POLOCKY__() ソースの最後によぶのが特徴です。

つまり、

 __PACKAGE__->meta->make_immutable( inline_destructor => 1 );

上記のソースのスペリングを覚えれないので、 エリアス的なものを用意したかったという不純な動機で作ったのは内緒です。
utf8が使えないのは小学生までなので、強制的にutf8されたりもします。

=head1 AUTHOR

polocky

=cut
