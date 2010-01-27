package Polocky::Logger;

use Polocky::Exceptions;
use Polocky::Utils;
use Polocky::Logger::Dispatch;

# XXX actually , this module is instance holder...
sub instance {
    my $class = shift;
    no strict 'refs';
    my $instance = \%{ "$class\::_instance" };
    defined $instance->{$class->app_sub_class}
        ? $instance->{$class->app_sub_class}
        : ($instance->{$class->app_sub_class} = $class->create_logger());
}

sub create_logger {
    my $self = shift;
    Polocky::Logger::Dispatch->new( app_class => $self->app_class .'::'. $self->app_sub_class );
}

sub app_sub_class {
    Polocky::Utils::app_sub_class;
}
sub app_class {
    Polocky::Utils::app_class;
}

1;
