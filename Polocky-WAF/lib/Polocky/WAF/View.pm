package Polocky::WAF::View;
use Polocky::Class;
use Polocky::Utils;
BEGIN { extends 'Polocky::Core' }

has 'engine' => ( 
    is => 'rw', 
    lazy_build => 1,
 );

has 'root' => (
    is          => 'rw',
    lazy_build  => 1,
);

has 'template_extension' => (
    is => 'rw',
    default => '.templ',
);

has content_type => (
    is => 'rw',
    default => 'text/html;charset=utf-8',
);

sub _build_root {
    my $self = shift;
    return [
        Polocky::Utils::structure->template_dir( Polocky::Utils::app_sub_name ),
        Polocky::Utils::structure->template_dir( 'share' )->subdir( Polocky::Utils::app_sub_name ),
        Polocky::Utils::structure->template_dir( 'share' )->subdir( 'common' ),
    ]
}

sub _build_engine {
    Polocky::Exception::AbstractMethod->throw(
        message => 'Sub class must overried this method' );
}   

sub _build_stash {
    my ( $self, $c ) = @_;
    $c->stash->{c} = $c;
    $c->stash->{config} = $c->config;
}
sub render {
    my $self = shift;
    my $c    = shift;
    $self->_build_template( $c );
    $self->_build_stash( $c );
    my $output = $self->_do_render( $c );
    $self->_build_response( $c , $output );
    return 1;
}

sub _build_template {
    my $self = shift;
    my $c    = shift;

    unless( $c->stash->{template} ) {
        $c->stash->{template} = $c->action->reverse . $self->template_extension if $c->can('action');
    }
}

sub _do_render {
    my ( $self, $c ) = @_;
    return $self->_render( $c );
}

sub _render {
    Polocky::Exception::AbstractMethod->throw(
        message => '_render class must overried this method' );
}

sub _build_response {
    my ( $self, $c, $output ) = @_;
    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);

    unless ( $c->res->content_type ) {
        #$c->logger->warning('You forget to set content_type >_<');
        $c->res->content_type( $self->content_type );
    }

    1;
}

__POLOCKY__ ;

=head1 NAME

Polocky::View

=head1 SYNOPSIS

 Polocky::View->new()->render( $c );
 # $c で利用してるのは
 # 1. stash
 # 2. response
 # 3. request
 # 4. action  if can

=head1 DESCRIPTION





=cut
