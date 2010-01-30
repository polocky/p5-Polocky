package Polocky::WAF;
use Polocky::Class;
use Polocky::Utils;
use Polocky::Exceptions;
use UNIVERSAL::require;

our $VERAION = '0.04';

has 'logger' => (
    is      => 'rw',
    isa     => 'Polocky::Logger::Dispatch',
);
has 'structure' => (
    is      => 'rw',
    isa     => 'Polocky::Structure',
);
has 'config' => (
    is => 'rw',
    isa => 'Polocky::Config'
);

sub import {
    my $caller = shift;
    Polocky::Utils::init_registrar( $caller );
}
sub BUILD {
    my $self = shift;
    $self->setup;
}
sub setup {
    Polocky::Exception::AbstractMethod->throw('setup is abstract method');
}

sub setup_config {
    my $self = shift;
    my $config = $self->create_config;
    $self->config($config) ;
    $config;
}

sub create_config {
    my $self = shift;
    my $config_class = join '::', (Polocky::Utils::app_class ,'Config' );
    $config_class->require or Polocky::Exception::ClassNotFound->throw($@);
    $config_class->instance;
}

sub setup_structure {
    my $self = shift;
    my $structure = $self->create_structure;
    $self->structure($structure);
    $structure;
}

sub create_structure {
    my $self = shift;
    my $structure_class = join '::', ( Polocky::Utils::app_class, 'Structure' );
    $structure_class->require or Polocky::Exception::ClassNotFound->throw($@);
    $structure_class->instance;
}
sub setup_logger {
    my $self   = shift;
    my $logger = $self->create_logger;
    $self->logger($logger) ;
    $logger;
}

sub create_logger {
    my $self = shift;
    my $logger_class = join '::', ( Polocky::Utils::app_class, 'Logger' );
    $logger_class->require or Polocky::Exception::ClassNotFound->throw($@);
    $logger_class->instance;
}

__POLOCKY__;


