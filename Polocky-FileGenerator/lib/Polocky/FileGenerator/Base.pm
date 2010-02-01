package Polocky::FileGenerator::Base;
use Polocky::Class;
use Polocky::Exceptions;
use Polocky::Utils;
use IO::All -utf8;
extends qw(Polocky::Core MooseX::App::Cmd::Command);

has 'in_path' => (
    is => 'rw',
    lazy_build => 1,
);

has 'out_path' => (
    is => 'rw',
    lazy_build => 1,
);

has 'in_ext' => (
    is => 'rw',
    default => '.inc',
);
has 'out_ext' => (
    is => 'rw',
    default => '.inc',
);

has 'engine' => (
    is => 'rw',
    lazy_build => 1,
);

has 'name' => (
    is => 'rw',
    lazy_build => 1,
);


sub execute {
    Polocky::Exception::AbstractMethod->throw( message=>'Polocky::FileGenerator::Base->execute is abstract method' );
}

sub _build_name {
    my $self = shift;
    my $class = ref $self;
    my ($name) = $class =~ /::([a-zA-Z0-9_]+)$/;
    $name = lc $name;
}
sub _build_in_path {
    my $self = shift; 
    Polocky::Utils::structure->template_dir('share/file_base');
}
sub _build_out_path {
    my $self = shift; 
    Polocky::Utils::structure->template_dir('share/common/file');
}

sub _build_engine {
    Polocky::Exception::AbstractMethod->throw( message=>'Polocky::FileGenerator::Base->engine (_build_engine) is abstract method' );
}

sub get_out_file {
    my $self = shift;
    my $name = shift;
    $self->out_path->file( $name . $self->out_ext );
}

sub get_in_file {
    my $self = shift;
    my $name = shift;
    $self->in_path->file( $name . $self->in_ext );
}

sub generate {
    my $self = shift;
    my $args = shift || {};
    my $output = $self->build_output( $args );
    $self->write_file( $output , $args );
}

sub write_file {
    my $self    = shift;
    my $content = shift;
    my $args    = shift || {};
    my $name    = $args->{out_name} || $args->{name} || $self->name ;
    $args->{config} = $self->config;
    my $out_file = $self->get_out_file( $name );
    $self->logger->info( 'wrote file:' . $out_file );
    $content > io($out_file) ;
    1;
}

__POLOCKY__ ;
