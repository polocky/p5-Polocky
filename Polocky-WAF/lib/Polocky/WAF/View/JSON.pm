package Polocky::WAF::View::JSON;
use Polocky::Class;
use JSON::Syck;
extends 'Polocky::WAF::View';

has storage_key => ( 
    is => 'rw',
    default => 'json',
);

has charset => (
    is => 'rw',
    default => 'utf-8'
);

sub render {
    my ( $self, $c ) = @_;
    local $JSON::Syck::ImplicitUnicode = 1;
    my $data = $c->stash->{$self->storage_key } || {} ;
    my $json = JSON::Syck::Dump( $data );
    $c->res->content_type("application/json; charset=" . $self->charset );
    $self->_build_response( $c, $json );
    return 1;
}

__POLOCKY__ ;
