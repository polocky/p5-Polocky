package Polocky::WAF::Response;
use Polocky::Class;
use MooseX::NonMoose;
use Encode;
extends qw(Plack::Response);


sub _body {
    my $self = shift;
    my $body = $self->body;
       $body = [] unless defined $body;

    unless( $self->content_type =~ m!^(text/|application/json)!) {
        if (!ref $body or Scalar::Util::blessed($body) && overload::Method($body, q(""))) {
            return [$body];
        }
        else {
            return $body;
        }
    }

    if (!ref $body or Scalar::Util::blessed($body) && overload::Method($body, q(""))) {
        return [ Encode::encode('utf-8',$body ) ];
    } else {
        for( @$body ) {
            $_ =  Encode::encode('utf-8',$_ );
        }
        return $body;
    }
}


sub redirect {
    my $self = shift;
    $self->content_type("text/html");
    return $self->SUPER::redirect( @_ );
}

__POLOCKY__;
