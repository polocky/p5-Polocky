package Polocky::WAF::CatalystLike::DispatchType::Regex;

use Polocky::Class;
use Text::SimpleTable;
extends 'Polocky::WAF::CatalystLike::DispatchType::Path';

has _compiled => (
                  is => 'rw',
                  isa => 'ArrayRef',
                  required => 1,
                  default => sub{ [] },
                 );


sub list {
    my ( $self, $c ) = @_;
    my $avail_width = Polocky::Utils::term_width() - 9;
    my $col1_width = ($avail_width * .50) < 35 ? 35 : int($avail_width * .50);
    my $col2_width = $avail_width - $col1_width;
    my $re = Text::SimpleTable->new(
        [ $col1_width, 'Regex' ], [ $col2_width, 'Private' ]
    );
    for my $regex ( @{ $self->_compiled } ) {
        my $action = $regex->{action};
        $re->row( $regex->{path}, "/$action" );
    }
    $self->logger->debug( "Loaded Regex actions:\n" . $re->draw . "\n" )
      if ( @{ $self->_compiled } );
}


sub register {
    my ( $self, $action ) = @_;
    my $attrs    = $action->attributes;
    my @register = @{ $attrs->{'Regex'} || [] };

    foreach my $r (@register) {
        $self->register_path( $r, $action );
        $self->register_regex( $r, $action );
    }

    return 1 if @register;
    return 0;
}


sub register_regex {
    my ( $self,  $re, $action ) = @_;
    push(
        @{ $self->_compiled },    # and compiled regex for us
        {
            re     => qr#$re#,
            action => $action,
            path   => $re,
        }
    );
}

sub match {
    my ( $self, $c, $path ) = @_;

    return if $self->SUPER::match( $c, $path );

    # Check path against plain text first

    foreach my $compiled ( @{ $self->_compiled } ) {
        if ( my @captures = ( $path =~ $compiled->{re} ) ) {
            next unless $compiled->{action}->match($c);
            $c->req->action( $compiled->{path} );
            $c->req->match($path);
            $c->req->captures( \@captures );
            $c->action( $compiled->{action} );
            $c->namespace( $compiled->{action}->namespace );
            return 1;
        }
    }

    return 0;
}


__POLOCKY__

__END__
