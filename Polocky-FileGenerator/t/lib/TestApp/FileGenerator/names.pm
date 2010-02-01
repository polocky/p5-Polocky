package TestApp::FileGenerator::names;
use Polocky::Class;
extends qw(Polocky::FileGenerator::TT);

sub execute {
    my $self = shift ;
    my @names =qw(polocky oklahomer cubtan);
    $self->generate( { vars => { names => \@names } } );
    1;
}


__POLOCKY__;
