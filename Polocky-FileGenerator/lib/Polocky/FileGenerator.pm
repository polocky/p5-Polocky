package Polocky::FileGenerator;

our $VERSION = '0.01_13';

use Polocky::Class;
use Polocky::Exceptions;
extends qw(MooseX::App::Cmd);
sub plugin_search_path {
    Polocky::Exception::AbstractMethod->throw( message => 'Please Emplement Polocky::FileGenerator::plugin_search_path' );
}
__POLOCKY__ ;

=head1 NAME

Polocky::FileGenerator - ファイルを作成するCLIインターフェイスツール

=head1 DESCRIPTION

とてもアルファクォリティです。

バッチファイル作成を念頭に作成しています。

=head1 TODO

=head2 VIEWの連携

現在、独自にViewの仕組みを実装していますが、WAF::View との連携を行うように改善したい。
Polocky-View を作成し、両方そっちを継承するような形で。

=head1 AUTHOR

polocky

=cut
