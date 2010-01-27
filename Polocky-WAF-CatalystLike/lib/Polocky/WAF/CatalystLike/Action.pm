package Polocky::WAF::CatalystLike::Action;

use Polocky::Class;
use Scalar::Util 'looks_like_number';
use namespace::clean -except => 'meta';

has class      => (is => 'rw');
has namespace  => (is => 'rw');
has 'reverse'  => (is => 'rw');
has attributes => (is => 'rw');
has name       => (is => 'rw');
has code       => (is => 'rw');

use overload (
# Stringify to reverse for debug output etc.
        q{""} => sub { shift->{reverse} },
# Codulate to execute to invoke the encapsulated action coderef
        '&{}' => sub { my $self = shift; sub { $self->execute(@_); }; },
# Make general $stuff still work
        fallback => 1,
);

no warnings 'recursion';


sub dispatch {    # Execute ourselves against a context
    my ( $self, $c ) = @_;
    return $c->execute( $self->class, $self );
}

sub execute {
    my $self = shift;
    $self->code->(@_);
}

sub match {
    my ( $self, $c ) = @_;
#would it be unreasonable to store the number of arguments
#the action has as its own attribute?
#it would basically eliminate the code below.  ehhh. small fish
    return 1 unless exists $self->attributes->{Args};
    my $args = $self->attributes->{Args}[0];
    return 1 unless defined($args) && length($args);
    return scalar( @{ $c->req->args } ) == $args;
}

sub compare {
    my ($a1, $a2) = @_;

    my ($a1_args) = @{ $a1->attributes->{Args} || [] };
    my ($a2_args) = @{ $a2->attributes->{Args} || [] };

    $_ = looks_like_number($_) ? $_ : ~0 
        for $a1_args, $a2_args;

    return $a1_args <=> $a2_args;
}


__POLOCKY__ 

__END__
