package Polocky::WAF::CatalystLike::Component::Loader;
use Polocky::Class;
use Polocky::Utils;
use Polocky::Exceptions;
use Module::Pluggable::Object;
use MooseX::AttributeHelpers;
use Scalar::Util;
use Class::MOP;

with 'Polocky::Role::Configurable';

has 'components' => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef',
    default   => sub { +{} },
    provides => {
        exists => 'has_components',
        get    => 'get_component',
        set    => 'set_component',
    },
);

sub setup {
    my $self         = shift;
    my $app_system_name = shift;
    my $components = $self->load_components( $app_system_name ) ;
}

sub load_components {
    my $self = shift;
    my $app_system_name = shift;
    my @paths   = ( "::${app_system_name}::Controller" ,'::Model', "::${app_system_name}::View"  );
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { $self->app_class . $_ } @paths ], );

    my @comps = sort { length $a <=> length $b } $locator->plugins;
    my %comps = map { $_ => 1 } @comps;

    for my $component (@comps) {
        Class::MOP::load_class($component);

        my $module = $self->load_component($component);
        # SETUP hook
        $module->SETUP if $module->can('SETUP');

        $self->set_component( $component, $module );
    }
    $self->components;
}


sub load_component {
    my ( $self, $component ) = @_;
    #my $config = $self->_get_component_config($component);
    my $config = {};
    my $instance = eval { $component->new( %{$config} ) };

    if ( my $error = $@ ) {
        chomp $error;
        Polocky::Exception->throw( message => "Couldn't instantiate component $component : $error" );
    }

    Polocky::Exception->throw( message => "Couldn't instantiate component $component" ) unless Scalar::Util::blessed($instance);

    return $instance;
}

sub app_class {
    my $self = shift;
    Polocky::Utils::app_class;
}

# not using for now
sub _get_component_config {
    my ( $self, $component ) = @_;
    my $suffix = Polocky::Utils::class2classsuffix($component);
    my ( $component_type, $class_suffix ) = split "::", $suffix;
    return $self->config->components( lc($component_type), $class_suffix );
}


__POLOCKY__

__END__
