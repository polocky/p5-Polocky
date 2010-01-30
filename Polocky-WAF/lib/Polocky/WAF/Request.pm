package Polocky::WAF::Request;
use Polocky::Class;
use MooseX::NonMoose;
use Encode;
use Polocky::WAF::Response;
use URI::Escape ;

extends qw(Plack::Request);

has action => (is => 'rw');
has match => (is => 'rw');
has arguments => (is => 'rw', default => sub { [] });
has captures => (is => 'rw', default => sub { [] });
has stash => (is => 'rw', default => sub { {} });

{
    no warnings 'once';
    *args = \&arguments;
}

sub query_parameters {
    my $self = shift;
    $self->env->{'plack.request.query'} ||= return $self->decode_multivalue( Hash::MultiValue->new($self->uri->query_form) );
}
sub body_parameters {
    my $self = shift;
    unless ($self->env->{'plack.request.body'}) {
        $self->_parse_request_body;
        $self->decode_multivalue( $self->env->{'plack.request.body'} );
    }

    return $self->env->{'plack.request.body'};
}


sub decode_multivalue {
    my $self = shift;
    my $hash = shift;
    my $params = $hash->mixed;
    my $decoded_params = {};
    while (my($k, $v) = each %$params) {
        $decoded_params->{decode_utf8($k)} = ref $v eq 'ARRAY'
            ? [ map decode_utf8($_), @$v ] : decode_utf8($v);
    }
    return Hash::MultiValue->from_mixed(%$decoded_params);
}

sub new_response {
    my $self = shift;
    Polocky::WAF::Response->new(@_);
}

sub uri_build {
    my $self = shift;
    my $path_parts = shift || '/';
    my $args = shift || {} ;

    my $path = '/';

    if( ref $path_parts eq 'ARRAY' ){
        for (@$path_parts ) {
            $path .= URI::Escape::uri_escape_utf8( $_ ) . '/';
        }
    }
    else {
        $path = $path_parts;
    }
    
    my $uri = $self->base ;
    $uri->path_query( $path );
    $uri->query_form($args);
    return $uri;
}


__POLOCKY__;
