package Polocky::WAF::View::TT;
use Polocky::Class;
use Template;
extends 'Polocky::WAF::View';

has 'encoding' => (
    is      => 'rw',
    default => 'utf8',
);

has 'filters' => (
    is      => 'rw',
    lazy_build => 1,
);

has pre_process => (
    is => 'rw',
    default => 'common.inc',
);

has '+template_extension' => ( default => '.tt' );

sub _build_filters { {} }

sub _build_engine {
    my $self = shift;

    my $config = {
        ENCODING     => $self->encoding,
        FILTERS      => $self->filters,
        INCLUDE_PATH => ref $self->root eq 'ARRAY' ? $self->root : [ $self->root ],
        PRE_PROCESS =>  $self->pre_process
    };
    $self->fix_config( $config );
    my $tt = Template->new(%$config);
    return $tt;
}

sub fix_config { }

sub _render {
    my ( $self, $c ) = @_;
    my $out;
    unless( $self->engine->process( $c->stash->{template}, $c->stash , \$out )) {
        my $error
            = "Couldn't render template "
            . $c->stash->{template} . ": "
            . $self->engine->error;
        $c->logger->error($error);
        $c->res->status(500);
        $out = 'render error';
    }
    return $out;
}


__POLOCKY__ ;
