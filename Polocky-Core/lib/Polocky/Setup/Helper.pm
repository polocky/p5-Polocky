package Polocky::Setup::Helper;
use warnings;
use strict;
use base 'Module::Setup::Helper';
sub helper_option_prefix { 'polocky' }

sub helper_base_init {
    my $self = shift;

    open my $fh, '<', 'Makefile.PL' or die $!;
    local $/;
    my $makefile = <$fh>;
    my($module) = $makefile =~ /all_from 'lib\/(.+).pm'/;
    unless ($module) {
        return $self->{options}->{module} = shift @{ $self->{argv} };
    }
    $module =~ s{/}{::}g;
    $self->{options}->{module} = $module;
}


1;
