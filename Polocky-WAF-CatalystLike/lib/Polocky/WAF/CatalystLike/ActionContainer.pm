package Polocky::WAF::CatalystLike::ActionContainer;

use Polocky::Class;

has part => (is => 'rw', required => 1);
has actions => (is => 'rw', required => 1, lazy => 1, default => sub { {} });

around BUILDARGS => sub {
    my ($next, $self, @args) = @_;
    unshift @args, 'part' if scalar @args == 1 && !ref $args[0];
    return $self->$next(@args);
};

use overload (
    # Stringify to path part for tree search
    q{""} => sub { shift->part },
);

sub get_action {
    my ( $self, $name ) = @_;
    return $self->actions->{$name} if defined $self->actions->{$name};
    return;
}

sub add_action {
    my ( $self, $action, $name ) = @_;
    $name ||= $action->name;
    $self->actions->{$name} = $action;
}

__POLOCKY__

__END__
