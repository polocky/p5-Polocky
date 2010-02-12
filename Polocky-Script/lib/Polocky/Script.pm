package Polocky::Script;

our $VERSION = '0.01';

use Polocky::Class;
use Polocky::Exceptions;
extends qw(MooseX::App::Cmd);
sub plugin_search_path {
    Polocky::Exception::AbstractMethod->throw( message=>'Please Implement Polocky::Script::plugin_search_path' );
}
__POLOCKY__ ;

=head1 NAME

Polocky::Script - Polocky Script Tool

=head1 SYNOPSIS

 ./bin/myapp_helper Script CLI
 ./bin/cli sample --name 'Jack'

=head1 DESCRIPTION 

コマンドラインから処理を実行することができます。 

=head1 AUTHOR

polocky

=cut

