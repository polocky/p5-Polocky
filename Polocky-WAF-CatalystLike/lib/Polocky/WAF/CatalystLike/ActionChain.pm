package Polocky::WAF::CatalystLike::ActionChain;

use Polocky::Class;
extends qw(Polocky::WAF::CatalystLike::Action);

has chain => (is => 'rw');

sub dispatch {
    my ( $self, $c ) = @_;
    my @captures = @{$c->req->captures||[]};
    my @chain = @{ $self->chain };
    my $last = pop(@chain);
    foreach my $action ( @chain ) {
        my @args;
        if (my $cap = $action->attributes->{CaptureArgs}) {
          @args = splice(@captures, 0, $cap->[0]);
        }
        local $c->req->{arguments} = \@args;
        $action->dispatch( $c );
    }
    $last->dispatch( $c );
}

sub from_chain {
    my ( $self, $actions ) = @_;
    my $final = $actions->[-1];
    return $self->new({ %$final, chain => $actions });
}


__POLOCKY__

__END__
