package Polocky::WAF::CatalystLike::Dispatcher;
use Polocky::Class;
extends 'Polocky::Core';
use Tree::Simple;
use Polocky::WAF::CatalystLike::ActionContainer;
use Polocky::Utils;
use Text::SimpleTable;
use Polocky::Exceptions;

with 'Polocky::Role::Logger';

has _registered_dispatch_types => (
    is => 'rw', 
    default => sub { {} }, 
    required => 1, 
    lazy => 1
);
has _dispatch_types => (
    is => 'rw', 
    default => sub { [] }, 
    required => 1, 
    lazy => 1
);
has _action_hash => (is => 'rw', required => 1, lazy => 1, default => sub { {} });
has _container_hash => (is => 'rw', required => 1, lazy => 1, default => sub { {} });
has _tree => (is => 'rw', builder => '_build__tree');

sub _build__tree {
  my ($self) = @_;
  my $container = Polocky::WAF::CatalystLike::ActionContainer->new( { part => '/', actions => {} } );
  return Tree::Simple->new($container, Tree::Simple->ROOT);
}

has preload_dispatch_types => (
        is => 'rw', 
        required => 1, 
        lazy => 1, 
        default => sub { [qw/Path Regex/] },
 );

# setup_action
sub setup {
    my $self       = shift;
    my $components = shift;

    my @classes =
        $self->_load_dispatch_types( @{ $self->preload_dispatch_types } );
    @{ $self->_registered_dispatch_types }{@classes} = (1) x @classes;

    for my $comp ( values  %$components  ) {
        $comp->register_actions( $self ) if $comp->isa('Polocky::WAF::CatalystLike::Controller');
    }

    #$self->_display_action_tables();
}
sub _load_dispatch_types {
    my ( $self, @types ) = @_;

    my @loaded;
    for my $type (@types) {
        my $class = 'Polocky::WAF::CatalystLike::DispatchType::' . $type;
        Class::MOP::load_class($class) ;
        push @{ $self->_dispatch_types }, $class->new;

        push @loaded, $class;
    }

    return @loaded;
}

sub _display_action_tables {
    my $self = shift;

    my $column_width = Polocky::Utils::term_width() - 20 - 36 - 12;
    my $privates = Text::SimpleTable->new(
        [ 20, 'Private' ], [ 36, 'Class' ], [ $column_width, 'Method' ]
    );

    my $has_private = 0;
    my $walker = sub {
        my ( $walker, $parent, $prefix ) = @_;
        $prefix .= $parent->getNodeValue || '';
        $prefix .= '/' unless $prefix =~ /\/$/;
        my $node = $parent->getNodeValue->actions;

        for my $action ( keys %{$node} ) {
            my $action_obj = $node->{$action};
            #next if ( ( $action =~ /^_.*/ ) && ( !$c->config->{show_internal_actions} ) );
            next if ( $action =~ /^_.*/ );
            $privates->row( "$prefix$action", $action_obj->class, $action );
            $has_private = 1;
        }

        $walker->( $walker, $_, $prefix ) for $parent->getAllChildren;
    };

    $walker->( $walker, $self->_tree, '' );
    $self->logger->debug( "Loaded Private actions:\n" . $privates->draw . "\n" ) if $has_private;

    # List all public actions
    $_->list() for @{ $self->_dispatch_types };
}


sub register {
    my ( $self, $action ) = @_;
    my $registered = $self->_registered_dispatch_types;

    foreach my $key ( keys %{ $action->attributes } ) {
        next if $key eq 'Private';
        my $class = "Polocky::WAF::CatalystLike::DispatchType::$key";
        unless ( $registered->{$class} ) {
            eval { Class::MOP::load_class($class) };
            push( @{ $self->_dispatch_types }, $class->new ) unless $@;
            $registered->{$class} = 1;
        }
    }

    my @dtypes = @{ $self->_dispatch_types };
    my @normal_dtypes;
    my @low_precedence_dtypes;
#
    for my $type ( @dtypes ) {
        if ($type->_is_low_precedence) {
            push @low_precedence_dtypes, $type;
        } else {
            push @normal_dtypes, $type;
        }
    }

    # Pass the action to our dispatch types so they can register it if reqd.
    my $was_registered = 0;
    foreach my $type ( @normal_dtypes ) {
        $was_registered = 1 if $type->register( $action );
    }

    if (not $was_registered) {
        foreach my $type ( @low_precedence_dtypes ) {
            $type->register( $action );
        }
    }

    my $namespace = $action->namespace;
    my $name      = $action->name;

    my $container = $self->_find_or_create_action_container($namespace);


    # Set the method value
    $container->add_action($action);

    $self->_action_hash->{"$namespace/$name"} = $action;
    $self->_container_hash->{$namespace} = $container;

}

sub _find_or_create_action_container {
    my ( $self, $namespace ) = @_;

    my $tree ||= $self->_tree;

    return $tree->getNodeValue unless $namespace;

    my @namespace = split '/', $namespace;
    return $self->_find_or_create_namespace_node( $tree, @namespace )->getNodeValue;
}

sub _find_or_create_namespace_node {
    my ( $self, $parent, $part, @namespace ) = @_;

    return $parent unless $part;

    my $child =
      ( grep { $_->getNodeValue->part eq $part } $parent->getAllChildren )[0];

    unless ($child) {
        my $container = Polocky::WAF::CatalystLike::ActionContainer->new($part);
        $parent->addChild( $child = Tree::Simple->new($container) );
    }

    $self->_find_or_create_namespace_node( $child, @namespace );
}

sub dispatch {
    my ( $self, $c ) = @_;
    if ( my $action = $c->action ) {
        $c->forward( join( '/', '', $action->namespace, '_DISPATCH' ) );
    }
    else {
        my $path  = $c->req->path_info;
        my $error = $path
          ? qq/Unknown resource "$path"/
          : "No default action defined";
        #$c->log->error($error) if $c->debug;
        #$c->error($error);
    }
}
sub forward {
    my $self = shift;
    no warnings 'recursion';
    $self->_do_forward(forward => @_);
}
sub detach {
    my ( $self, $c, $command, @args ) = @_;
    $self->_do_forward(detach => $c, $command, @args ) if $command;
    Polocky::Exception::Detach->throw;
}



sub _do_forward {
    my $self = shift;
    my $opname = shift;
    my ( $c, $command ) = @_;
    my ( $action, $args, $captures ) = $self->_command2action(@_);

    local $c->req->{arguments} = $args;
    no warnings 'recursion';
    #warn 'try:'. $action->name;
    $action->dispatch( $c );
    return $c->state;
}

sub _command2action {
    my ( $self, $c, $command, @extra_params ) = @_;

    unless ($command) {
        #$c->log->debug('Nothing to go to') if $c->debug;
        return 0;
    }

    my (@args, @captures);
    @args = @{ $c->req->arguments };
    
    my $action;
    if (blessed($command) && $command->isa('Polocky::WAF::CatalystLike::Action')) {
        $action = $command;
    }else {
        $action = $self->_invoke_as_path( $c, "$command", \@args );
    }

     return $action, \@args, \@captures;

}
sub _invoke_as_path {
    my ( $self, $c, $rel_path, $args ) = @_;

    my $path = $self->_action_rel2abs( $c, $rel_path );

    my ( $tail, @extra_args );
    while ( ( $path, $tail ) = ( $path =~ m#^(?:(.*)/)?(\w+)?$# ) ) {  
        if ( my $action = $c->get_action( $tail, $path ) ) {
            push @$args, @extra_args;
            return $action;
        }
        else {
            return unless $path ; # if a match on the global namespace failed then the whole lookup failed
        }

        unshift @extra_args, $tail;
    }
}
sub get_action {
    my ( $self, $name, $namespace ) = @_;
    return unless $name;
    $namespace = join( "/", grep { length } split '/', ( defined $namespace ? $namespace : "" ) );
    return $self->_action_hash->{"${namespace}/${name}"};
}


sub _action_rel2abs {
    my ( $self, $c, $path ) = @_;

    unless ( $path =~ m#^/# ) {
        my $namespace = $c->stack->[-1]->namespace;
        $path = "$namespace/$path";
    }

    $path =~ s#^/##;
    return $path;
}



sub prepare_action {
    my ( $self, $c ) = @_;
    my $req = $c->req;
    my $path = $req->path_info;
    my @path = split /\//, $req->path_info;
    $req->args( \my @args );

    unshift( @path, '' );    # Root action

  DESCEND: while (@path) {
        $path = join '/', @path;
        $path =~ s#^/+##;

        # Check out dispatch types to see if any will handle the path at
        # this level

        foreach my $type ( @{ $self->_dispatch_types } ) {
            last DESCEND if $type->match( $c, $path );
        }

        # If not, move the last part path to args
        my $arg = pop(@path);
        $arg =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;
        unshift @args, $arg;
    }

    s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg for grep { defined } @{$req->captures||[]};
    #$c->log->debug( 'Path is "' . $req->match . '"' )
    #  if ( $c->debug && defined $req->match && length $req->match );

    #$c->log->debug( 'Arguments are "' . join( '/', @args ) . '"' )
    #  if ( $c->debug && @args );
}


sub get_actions {
    my ( $self, $c, $action, $namespace ) = @_;
    return [] unless $action;

    $namespace = join( "/", grep { length } split '/', $namespace || "" );

    my @match = $self->get_containers($namespace);

    return map { $_->get_action($action) } @match;
}
sub get_containers {
    my ( $self, $namespace ) = @_;
    $namespace ||= '';
    $namespace = '' if $namespace eq '/';

    my @containers;

    if ( length $namespace ) {
        do {
            push @containers, $self->_container_hash->{$namespace};
        } while ( $namespace =~ s#/[^/]+$## );
    }

    return reverse grep { defined } @containers, $self->_container_hash->{''};
}

__POLOCKY__

__END__
