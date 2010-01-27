package Polocky::WAF::CatalystLike::Plugin::ShowDispatcher;
use Polocky::Role;
use Text::SimpleTable;

after 'SETUP' => sub {
    my $c = shift;
    $c->dispatcher->_display_action_tables();
};

after 'PREPARE' => sub {
    my $c = shift;

    # BODY 
    if( keys %{ $c->req->body_parameters } ) {
        my $t = Text::SimpleTable->new( [ 35, 'Parameter' ], [ 36, 'Value' ] );
        for my $key ( sort keys %{ $c->req->body_parameters } ) {
            my $param = $c->req->body_parameters->{$key};
            my $value = defined($param) ? $param : '';
            $t->row( $key,
                    ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
        }
        $c->logger->debug( "Body Parameters are:\n" . $t->draw );
    }

    # QUERY
    if ( keys %{ $c->req->query_parameters } ) {
        my $t = Text::SimpleTable->new( [ 35, 'Parameter' ], [ 36, 'Value' ] );
        for my $key ( sort keys %{ $c->req->query_parameters } ) {
            my $param = $c->req->query_parameters->{$key};
            my $value = defined($param) ? $param : '';
            $t->row( $key,
                ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
        }
        $c->logger->debug( "Query Parameters are:\n" . $t->draw );
    }

};

1;
