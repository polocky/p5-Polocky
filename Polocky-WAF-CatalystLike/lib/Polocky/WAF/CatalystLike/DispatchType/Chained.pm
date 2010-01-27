package Polocky::WAF::CatalystLike::DispatchType::Chained;

use Polocky::Class;
extends 'Polocky::WAF::CatalystLike::DispatchType';
with 'Polocky::Role::Logger';
use Text::SimpleTable;
use Polocky::WAF::CatalystLike::ActionChain;

use Scalar::Util ();

has _endpoints => (
                   is => 'rw',
                   isa => 'ArrayRef',
                   required => 1,
                   default => sub{ [] },
                  );

has _actions => (
                 is => 'rw',
                 isa => 'HashRef',
                 required => 1,
                 default => sub{ {} },
                );

has _children_of => (
                     is => 'rw',
                     isa => 'HashRef',
                     required => 1,
                     default => sub{ {} },
                    );

sub list {
    my ( $self, $c ) = @_;
    return unless $self->_endpoints;

    my $avail_width = Polocky::Utils::term_width() - 9;
    my $col1_width = ($avail_width * .50) < 35 ? 35 : int($avail_width * .50);
    my $col2_width = $avail_width - $col1_width;
    my $paths = Text::SimpleTable->new(
        [ $col1_width, 'Path Spec' ], [ $col2_width, 'Private' ],
    );

    my $has_unattached_actions;
    my $unattached_actions = Text::SimpleTable->new(
        [ $col1_width, 'Private' ], [ $col2_width, 'Missing parent' ],
    );

    ENDPOINT: foreach my $endpoint (
                  sort { $a->reverse cmp $b->reverse }
                           @{ $self->_endpoints }
                  ) {
        my $args = $endpoint->attributes->{Args}->[0];
        my @parts = (defined($args) ? (("*") x $args) : '...');
        my @parents = ();
        my $parent = "DUMMY";
        my $curr = $endpoint;
        while ($curr) {
            if (my $cap = $curr->attributes->{CaptureArgs}) {
                unshift(@parts, (("*") x $cap->[0]));
            }
            if (my $pp = $curr->attributes->{PartPath}) {
                unshift(@parts, $pp->[0])
                    if (defined $pp->[0] && length $pp->[0]);
            }
            $parent = $curr->attributes->{Chained}->[0];
            $curr = $self->_actions->{$parent};
            unshift(@parents, $curr) if $curr;
        }
        if ($parent ne '/') {
            $has_unattached_actions = 1;
            $unattached_actions->row('/' . ($parents[0] || $endpoint)->reverse, $parent);
            next ENDPOINT;
        }
        my @rows;
        foreach my $p (@parents) {
            my $name = "/${p}";
            if (my $cap = $p->attributes->{CaptureArgs}) {
                $name .= ' ('.$cap->[0].')';
            }
            unless ($p eq $parents[0]) {
                $name = "-> ${name}";
            }
            push(@rows, [ '', $name ]);
        }
        push(@rows, [ '', (@rows ? "=> " : '')."/${endpoint}" ]);
        $rows[0][0] = join('/', '', @parts) || '/';
        $paths->row(@$_) for @rows;
    }

    $self->logger->debug( "Loaded Chained actions:\n" . $paths->draw . "\n" );
    $self->logger->debug( "Unattached Chained actions:\n", $unattached_actions->draw . "\n" )
        if $has_unattached_actions;
}


sub register {
    my ( $self, $action ) = @_;

    my @chained_attr = @{ $action->attributes->{Chained} || [] };

    return 0 unless @chained_attr;

    if (@chained_attr > 1) {
        Polocky::Exception->throw(
          "Multiple Chained attributes not supported registering ${action}"
        );
    }
    my $chained_to = $chained_attr[0];

    Polocky::Exception->throw(
      "Actions cannot chain to themselves registering /${action}"
    ) if ($chained_to eq '/' . $action);

    my $children = ($self->_children_of->{ $chained_to } ||= {});

    my @path_part = @{ $action->attributes->{PathPart} || [] };

    my $part = $action->name;

    if (@path_part == 1 && defined $path_part[0]) {
        $part = $path_part[0];
    } elsif (@path_part > 1) {
        Polocky::Exception->throw(
          "Multiple PathPart attributes not supported registering " . $action->reverse()
        );
    }

    if ($part =~ m(^/)) {
        Polocky::Exception->throw(
          "Absolute parameters to PathPart not allowed registering " . $action->reverse()
        );
    }

    $action->attributes->{PartPath} = [ $part ];

    unshift(@{ $children->{$part} ||= [] }, $action);

    $self->_actions->{'/'.$action->reverse} = $action;

    if (exists $action->attributes->{Args}) {
        my $args = $action->attributes->{Args}->[0];
        if (defined($args) and not (
            Scalar::Util::looks_like_number($args) and
            int($args) == $args
        )) {
            require Data::Dumper;
            local $Data::Dumper::Terse = 1;
            local $Data::Dumper::Indent = 0;
            $args = Data::Dumper::Dumper($args);
            Polocky::Exception->throw(
              "Invalid Args($args) for action " . $action->reverse() .
              " (use 'Args' or 'Args(<number>)'"
            );
        }
    }

    unless ($action->attributes->{CaptureArgs}) {
        unshift(@{ $self->_endpoints }, $action);
    }

    return 1;
}

sub match {
    my ( $self, $c, $path ) = @_;

    my $request = $c->req;
    return 0 if @{$request->args};

    my @parts = split('/', $path);

    my ($chain, $captures, $parts) = $self->recurse_match($c, '/', \@parts);

    if ($parts && @$parts) {
        for my $arg (@$parts) {
            $arg =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;
            push @{$request->args}, $arg;
        }
    }

    return 0 unless $chain;

    my $action = Polocky::WAF::CatalystLike::ActionChain->from_chain($chain);

    $request->action("/${action}");
    $request->match("/${action}");
    $request->captures($captures);
    $c->action($action);
    $c->namespace( $action->namespace );

    return 1;
}


sub recurse_match {
    my ( $self, $c, $parent, $path_parts ) = @_;
    my $children = $self->_children_of->{$parent};
    return () unless $children;
    my $best_action;
    my @captures;
    TRY: foreach my $try_part (sort { length($b) <=> length($a) }
                                   keys %$children) {
                               # $b then $a to try longest part first
        my @parts = @$path_parts;
        if (length $try_part) { # test and strip PathPart
            next TRY unless
              ($try_part eq join('/', # assemble equal number of parts
                              splice( # and strip them off @parts as well
                                @parts, 0, scalar(@{[split('/', $try_part)]})
                              ))); # @{[]} to avoid split to @_
        }
        my @try_actions = @{$children->{$try_part}};
        TRY_ACTION: foreach my $action (@try_actions) {
            if (my $capture_attr = $action->attributes->{CaptureArgs}) {

                # Short-circuit if not enough remaining parts
                next TRY_ACTION unless @parts >= $capture_attr->[0];

                my @captures;
                my @parts = @parts; # localise

                # strip CaptureArgs into list
                push(@captures, splice(@parts, 0, $capture_attr->[0]));

                # try the remaining parts against children of this action
                my ($actions, $captures, $action_parts) = $self->recurse_match(
                                             $c, '/'.$action->reverse, \@parts
                                           );
                #    No best action currently
                # OR The action has less parts
                # OR The action has equal parts but less captured data (ergo more defined)
                if ($actions    &&
                    (!$best_action                                 ||
                     $#$action_parts < $#{$best_action->{parts}}   ||
                     ($#$action_parts == $#{$best_action->{parts}} &&
                      $#$captures < $#{$best_action->{captures}}))){
                    $best_action = {
                        actions => [ $action, @$actions ],
                        captures=> [ @captures, @$captures ],
                        parts   => $action_parts
                        };
                }
            }
            else {
                {
                    local $c->req->{arguments} = [ @{$c->req->args}, @parts ];
                    next TRY_ACTION unless $action->match($c);
                }
                my $args_attr = $action->attributes->{Args}->[0];

                #    No best action currently
                # OR This one matches with fewer parts left than the current best action,
                #    And therefore is a better match
                # OR No parts and this expects 0
                #    The current best action might also be Args(0),
                #    but we couldn't chose between then anyway so we'll take the last seen

                if (!$best_action                       ||
                    @parts < @{$best_action->{parts}}   ||
                    (!@parts && $args_attr eq 0)){
                    $best_action = {
                        actions => [ $action ],
                        captures=> [],
                        parts   => \@parts
                    }
                }
            }
        }
    }
    return @$best_action{qw/actions captures parts/} if $best_action;
    return ();
}


__POLOCKY__

__END__
