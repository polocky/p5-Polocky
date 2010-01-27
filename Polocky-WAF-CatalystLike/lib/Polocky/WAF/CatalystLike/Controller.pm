package Polocky::WAF::CatalystLike::Controller;

use Polocky::Class;
BEGIN { extends 'Polocky::Core' }
use Moose::Util qw/find_meta/;
use namespace::clean -except => 'meta';
use MooseX::MethodAttributes;
use MooseX::Types::Moose qw/ArrayRef Str RoleName/;
use String::RewritePrefix;
use List::Util qw(first);

__PACKAGE__->mk_classdata( _dispatch_steps => [qw/_BEGIN _AUTO _ACTION/] );
__PACKAGE__->mk_classdata( _action_class   => 'Polocky::WAF::CatalystLike::Action' );
__PACKAGE__->mk_classdata( 'path' );
__PACKAGE__->mk_classdata( 'namespace' );
__PACKAGE__->mk_classdata( 'load_controller_mixins' );
__PACKAGE__->load_controller_mixins([]);

has _controller_mixins => (
    is         => 'rw',
    lazy_build => 1,
);

sub _build__controller_mixins {
    my $self = shift;
    my @mixins = $self->_expand_role_shortname( 'Mixin::', $self->load_controller_mixins );
    Class::MOP::load_class($_) for @mixins ;
    my @methods = ();
    for my $mixin ( @mixins ) {
        my $obj = $mixin->new();
        my $meta = find_meta($obj);
        push @methods , $meta->get_nearest_methods_with_attributes;
    }
    return \@methods;
}

sub _expand_role_shortname {
    my ($self, $type, $shortnames) = @_;
    my $app = Polocky::Utils::app_class;
    return String::RewritePrefix->rewrite(
        { 
            ''  => 'Polocky::WAF::CatalystLike::Controller::' . $type ,
            '~' => $app . '::WAF::CatalystLike::Controller::' . $type,
            '+' => '' 
        },
        @$shortnames,
    );
}

sub BUILD {
    my $self = shift;
    $self->_controller_mixins;
}
sub path_prefix  {
    my $self = shift;
    if( defined $self->path ) {
        return $self->path;
    }
    else {
        return  $self->action_namespace;
    }
};

sub action_namespace {
    my $self = shift;
    if( defined $self->namespace ){
        return $self->namespace;
    }
    else {
        return Polocky::Utils::class2prefix(ref $self ) || '';
    }
}

sub register_actions {
    my ( $self, $dispatcher ) = @_;
    $self->register_action_methods( $dispatcher , @{$self->_controller_mixins} );
    $self->register_action_methods( $dispatcher , $self->get_action_methods );
}

sub get_action_methods {
    my $self = shift;
    my $meta = find_meta($self);
    my @methods = $meta->get_nearest_methods_with_attributes;
    return @methods;
}

sub register_action_methods {
    my ( $self, $dispatcher ,@methods ) = @_;
    my $class = ref $self || $self;
    my $namespace = $self->action_namespace();

    foreach my $method (@methods) {
        my $name = $method->name;
        my $attributes = $method->attributes;
        my $attrs = $self->_parse_attrs( $name, @{ $attributes } );
        if ( $attrs->{Private} && ( keys %$attrs > 1 ) ) {
#            $c->log->debug( 'Bad action definition "'
#                    . join( ' ', @{ $attributes } )
#                    . qq/" for "$class->$name"/ )
#                if $c->debug;
            next;
        }
        my $reverse = $namespace ? "${namespace}/${name}" : $name;
        my $action = $self->create_action(
                name       => $name,
                code       => $method->body,
                #code       => sub { shift->$name(@_) },
                reverse    => $reverse,
                namespace  => $namespace,
                class      => $class,
                attributes => $attrs,
                );

        $dispatcher->register( $action );
    }
}

sub create_action {
    my $self = shift;
    my %args = @_;

    my $class = (exists $args{attributes}{ActionClass}
                    ? $args{attributes}{ActionClass}[0]
                    : $self->_action_class);

    Class::MOP::load_class($class);

    # Steal code from Catalyst::Controller::ActionRole
    # Plugin
    my @roles = ( @{$args{attributes}->{Plugin} || []});

    if (@roles) {
        Class::MOP::load_class($_) for @roles;
        my $meta = Moose::Meta::Class->initialize($class)->create_anon_class(
            superclasses => [$class],
            roles        => \@roles,
            cache        => 1,
        );
        $meta->add_method(meta => sub { $meta });
        $class = $meta->name;
    }

    return $class->new( \%args );
}


sub _parse_attrs {
    my ( $self, $name, @attrs ) = @_;

    my %raw_attributes;

    foreach my $attr (@attrs) {
     
        # Parse out :Foo(bar) into Foo => bar etc (and arrayify)

        if ( my ( $key, $value ) = ( $attr =~ /^(.*?)(?:\(\s*(.+?)\s*\))?$/ ) )
        {

            if ( defined $value ) {
                ( $value =~ s/^'(.*)'$/$1/ ) || ( $value =~ s/^"(.*)"/$1/ );
            }
            push( @{ $raw_attributes{$key} }, $value );
        }
    }

    my %final_attributes;

    foreach my $key (keys %raw_attributes) {

        my $raw = $raw_attributes{$key};

        foreach my $value (ref($raw) eq 'ARRAY' ? @$raw : $raw) {

            my $meth = "_parse_${key}_attr";
            if ( my $code = $self->can($meth) ) {
                ( $key, $value ) = $self->$code( $name, $value );
            }
            push( @{ $final_attributes{$key} }, $value );
        }
    }

    return \%final_attributes;
}

sub _parse_Plugin_attr {
    my ($self, $name, $value) = @_;
    return Plugin => $self->_expand_role_shortname('Plugin::' , [$value]);
}

sub _parse_Path_attr {
    my ( $self, $name, $value ) = @_;
    $value = '' if !defined $value;
    if ( $value =~ m!^/! ) {
        return ( 'Path', $value );
    }
    elsif ( length $value ) {
        return ( 'Path', join( '/', $self->path_prefix(), $value ) );
    }
    else {
        return ( 'Path', $self->path_prefix() );
    }
}


sub _parse_Local_attr {
    my ( $self, $name, $value ) = @_;
    return $self->_parse_Path_attr( $name, $name );
}

sub _parse_Regex_attr {
    my ( $self, $name, $value ) = @_;
    return ( 'Regex', $value );
}

sub _parse_LocalRegex_attr {
    my ( $self, $name, $value ) = @_;
    unless ( $value =~ s/^\^// ) { $value = "(?:.*?)$value"; }
    my $prefix = $self->path_prefix();
    $prefix .= '/' if length( $prefix );
    return ( 'Regex', "^${prefix}${value}" );
}

sub _parse_Chained_attr {
    my ($self,  $name, $value) = @_;

    if (defined($value) && length($value)) {
        if ($value eq '.') {
            $value = '/'.$self->action_namespace();
        } elsif (my ($rel, $rest) = $value =~ /^((?:\.{2}\/)+)(.*)$/) {
            my @parts = split '/', $self->action_namespace();
            my @levels = split '/', $rel;

            $value = '/'.join('/', @parts[0 .. $#parts - @levels], $rest);
        } elsif ($value !~ m/^\//) {
            my $action_ns = $self->action_namespace();

            if ($action_ns) {
                $value = '/'.join('/', $action_ns, $value);
            } else {
                $value = '/'.$value; # special case namespace '' (root)
            }
        }
    } else {
        $value = '/'
    }

    return Chained => $value;
}

sub _parse_ChainedParent_attr {
    my ($self, $c, $name, $value) = @_;
    return $self->_parse_Chained_attr( $name, '../'.$name);
}

sub _parse_PathPrefix_attr {
    my ( $self, $c ) = @_;
    return PathPart => $self->path_prefix();
}


sub _parse_ActionClass_attr {
    my ( $self, $c, $name, $value ) = @_;
    my $pkg = $self->_action_class . '::' . $name;
    return ( 'ActionClass',  $pkg ) ;
}

sub _DISPATCH : Private {
    my ( $self, $c ) = @_;

    foreach my $disp ( @{ $self->_dispatch_steps } ) {
        last unless $c->forward($disp);
    }

    $c->forward('_END');
}

sub _BEGIN : Private {
    my ( $self, $c ) = @_;
    my $begin = ( $c->get_actions( 'begin', $c->namespace ) )[-1];
    return 1 unless $begin;
    $begin->dispatch( $c );
    return !@{ $c->error };
}

sub _AUTO : Private {
    my ( $self, $c ) = @_;
    my @auto = $c->get_actions( 'auto', $c->namespace );
    foreach my $auto (@auto) {
        $auto->dispatch( $c );
        return 0 unless $c->state;
    }
    return 1;
}

sub _ACTION : Private {
    my ( $self, $c ) = @_;
    if (   ref $c->action && $c->action->can('execute') && defined $c->req->action ) {
        $c->action->dispatch( $c );
    }
    return !@{ $c->error };
}

sub _END : Private {
    my ( $self, $c ) = @_;
    my $end = ( $c->get_actions( 'end', $c->namespace ) )[-1];
    return 1 unless $end;
    $end->dispatch( $c );
    #return !@{ $c->error };
    return 1;
}




__POLOCKY__

__END__
