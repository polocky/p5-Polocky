package Polocky::Logger::Dispatch;
use Polocky::Class;
use Log::Dispatch::Config;
use Polocky::Logger::Dispatch::Configurator;
use Polocky::Utils;
use Storable qw/dclone/;


with 'Polocky::Role::Configurable';
has 'logger' => (
    is      => 'rw',
    lazy_build => 1,
    handles => [qw/debug warning info critical notice error/],


);

$Log::Dispatch::Config::CallerDepth = 2;


has 'app_class' => (
    is  => 'rw',
    isa => 'Str',
);

sub _build_logger {
    my $self = shift;

    my $logger = join '::', ( Polocky::Utils::app_class, Polocky::Utils::app_sub_class, 'Logger', 'Backend' );
    $self->_generate_logger_class($logger);
    Class::MOP::load_class($logger);
    my $config =  dclone($self->config->logger ) ;
    my $configure = Polocky::Logger::Dispatch::Configurator->new( $config ) ;
    $logger->configure( $configure );
    $logger->instance;
}

sub _generate_logger_class {
    my ( $self, $logger ) = @_;
    ## no critic
    eval <<"";
        package $logger;
        use base qw/Log\::Dispatch\::Config/;

}

__POLOCKY__

__END__
