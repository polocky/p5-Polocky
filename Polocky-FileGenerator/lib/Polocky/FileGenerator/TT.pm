package Polocky::FileGenerator::TT;
use Polocky::Class;
use Polocky::Exceptions;
use Template;
extends qw(Polocky::FileGenerator::Base MooseX::App::Cmd::Command);

has 'in_ext' => (
    is => 'rw',
    default => '.tt',
);

has pre_process => (
    is => 'rw',
    default => 'common.inc',
);

has 'filters' => (
    is      => 'rw',
    lazy_build => 1,
);

sub _build_filters { {} }

has 'root' => (
    is          => 'rw',
    lazy_build  => 1,
);

sub _build_root {
    my $self = shift;
    return [
        $self->in_path,
        Polocky::Utils::structure->template_dir( 'share' )->subdir( 'common' ),
    ]
}
sub _build_engine {
    my $self = shift;
    my $config = {
        ENCODING  => 'utf8',
        FILTERS      => $self->filters,
        INCLUDE_PATH => $self->in_path, 
        INCLUDE_PATH => ref $self->root eq 'ARRAY' ? $self->root : [ $self->root ],
        PRE_PROCESS =>  $self->pre_process
    };
    $self->fix_config( $config );
    return Template->new( %$config );
}
sub fix_config { }

sub build_output {
    my $self = shift;
    my $args = shift || {} ;
    my $vars = $args->{vars};
    $self->_build_vars( $vars );
    my $file = $self->get_in_file( $args->{name} || $self->name ) ;
    $self->engine->process( $file , $vars , \my $out ) or die $@;
    return $out;
}
sub _build_vars {
    my $self = shift;
    my $vars = shift;
    $vars->{config} = $self->config;
}

sub get_in_file {
    my $self = shift;
    my $name = shift;
    return $name . $self->in_ext ;
}

__POLOCKY__;
