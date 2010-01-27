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

# copy from Tatsumaki::Request
sub _build_parameters {
    my $self = shift;
    my $params = $self->SUPER::_build_parameters();
    my $decoded_params = {};
    while (my($k, $v) = each %$params) {
        $decoded_params->{decode_utf8($k)} = ref $v eq 'ARRAY'
            ? [ map decode_utf8($_), @$v ] : decode_utf8($v);
    }
    return $decoded_params;
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
