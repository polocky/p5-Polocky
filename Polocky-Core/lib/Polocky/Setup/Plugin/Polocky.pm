package Polocky::Setup::Plugin::Polocky;
use strict;
use warnings;
use base 'Module::Setup::Plugin';
use Polocky::Utils;
use Config;

sub register {
    my ( $self, ) = @_;
    $self->add_trigger(
            'after_setup_template_vars' => \&after_setup_template_vars );
}

sub after_setup_template_vars {
    my ( $self, $config ) = @_;
    my $name = $self->distribute->{module};
    my $new_config = +{
        polocky_name        => $name,
                            polocky_dir         => $self->distribute->{dist_path},
                            polocky_bin         => $self->distribute->{dist_path}->subdir('bin'),
                            polocky_appprefix   => Polocky::Utils::appprefix($name),
                            polocky_startperl   => "#!$Config{perlpath} -w",
                            polocky_core_version=> $Polocky::Core::VERSION,
    };

    while (my($key, $val) = each %{ $new_config }) {
        $config->{$key} = $val;
    }
}

1;
