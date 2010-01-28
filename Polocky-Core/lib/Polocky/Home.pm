package Polocky::Home;
use strict;
use warnings;
use Cwd;
use Path::Class qw(dir file);
use Polocky::Utils ;

# Do you know a song called 'Home Sweet Home' ?
sub detect {
    my ( $self , $app_class ) = @_;
    my $home;
    $home = $self->_get_home_from_application_env( $app_class ) if $app_class ;
    $home = $self->_current_dir unless $home;
    $home;
}
sub _get_home_from_application_env {
    my ( $self , $app_class ) = @_;
    if ( my $env = Polocky::Utils::env_value( $app_class ,  'HOME' ) ) {
        my $home = dir($env)->absolute->cleanup;
        return $home if -d $home;
    }
    return;
}
sub _current_dir {
    Cwd::getcwd;
}

1;

=head1 NAME

Polocky::Home - ポロキィのお家

=head1 DESCRIPTION

ポロキィのお家(アプリケーションの位置)を見つけるモジュールです。

=head1 SYNOPSIS

 use Polocky::Home;
 my $home = Polocky::Home->detect( "MyApp" );

=head1 中身

プライオリティに沿って、順番に見つけて行きます。

=head2 1.MYAPP_HOME 環境編数

=head2 2.POLOCKY_HOME 環境変数

=head2 3. 現在の位置

=head1 SEE ALSO

L<Cwd>
L<Path::Class>
L<Polocky::Utils>

=cut
