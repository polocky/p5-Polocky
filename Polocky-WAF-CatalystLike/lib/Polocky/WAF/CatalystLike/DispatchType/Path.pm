package Polocky::WAF::CatalystLike::DispatchType::Path;

use Polocky::Class;
use Polocky::Utils;
use Text::SimpleTable;
extends 'Polocky::WAF::CatalystLike::DispatchType';
with 'Polocky::Role::Logger';

has _paths => (
        is => 'rw',
        isa => 'HashRef',
        required => 1,
        default => sub { +{} },
        );


sub list {
    my ( $self, $c ) = @_;
    my $column_width = Polocky::Utils::term_width() - 35 - 9;
    my $paths = Text::SimpleTable->new(
            [ 35, 'Path' ], [ $column_width, 'Private' ]
            );
    foreach my $path ( sort keys %{ $self->_paths } ) {
        my $display_path = $path eq '/' ? $path : "/$path";
        foreach my $action ( @{ $self->_paths->{$path} } ) {
            $paths->row( $display_path, "/$action" );
        }
    }
    $self->logger->debug( "Loaded Path actions:\n" . $paths->draw . "\n" ) if ( keys %{ $self->_paths } );
}

sub register {
    my ( $self, $action ) = @_;

    my @register = @{ $action->attributes->{Path} || [] };

    $self->register_path( $_, $action ) for @register;

    return 1 if @register;
    return 0;
}

sub register_path {
    my ( $self, $path, $action ) = @_;
    $path =~ s!^/!!;
    $path = '/' unless length $path;
    $path = URI->new($path)->canonical;
    $path =~ s{(?<=[^/])/+\z}{};

    $self->_paths->{$path} = [
        sort { $a->compare($b) } ($action, @{ $self->_paths->{$path} || [] })
    ];

    return 1;
}

sub match {
    my ( $self, $c, $path ) = @_;

    $path = '/' if !defined $path || !length $path;

    my @actions = @{ $self->_paths->{$path} || [] };

    foreach my $action ( @actions ) {
        next unless $action->match($c);
        $c->req->action($path);
        $c->req->match($path);
        $c->action($action);
        $c->namespace( $action->namespace );
        return 1;
    }

    return 0;
}


__POLOCKY__

__END__
