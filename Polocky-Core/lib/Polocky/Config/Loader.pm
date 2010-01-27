package Polocky::Config::Loader;
use strict;
use warnings;
use Polocky::Config::Validator;
use Data::Visitor::Callback;
use Polocky::Utils;

sub load {
    my ( $class , $structure ) = @_;
    my $global =  do($structure->config_global_file_path->stringify) || {};
    my $config = do($structure->config_file_path->stringify) || {};
    my $local  = -e $structure->config_local_file_path ? do($structure->config_local_file_path->stringify) : {};

    # XXX You may want to try to use Algorithm::Merge , instead
    %$config = ( %$global , %$config , %$local );

    my $schema = do($structure->config_schema_file_path->stringify);
    $class->validate_config($config, $schema);
    $class->_substitute_config($config);
    return $config;
}

sub load_internal {
    my ( $class , $structure ) = @_;
    my $config = do($structure->config_internal_file_path->stringify) || {};
    my $local  = -e $structure->config_internal_local_file_path ? do($structure->config_internal_local_file_path->stringify) : {};

    # XXX You may want to try to use Algorithm::Merge , instead
    %$config = ( %$config , %$local );

    my $schema = -e $structure->config_internal_schema_file_path ? do($structure->config_internal_schema_file_path->stringify) : $class->config_internal_shcema ;
    $class->validate_config($config, $schema);
    $class->_substitute_config($config);
    $class->_fix_plugin_tree( $config->{default} );
    foreach my $key ( keys %{$config->{application}} ) {
        $class->_fix_plugin_tree( $config->{application}{$key} );
    } 
    return $config;
}

sub config_internal_shcema {
    return {
        'mapping' => {
            'application' => {
                'type' => 'any',
            },
            'default' => {
                'type' => 'any',
            },
        },
        'type' => 'map',
    };

}


sub _fix_plugin_tree {
    my $self = shift;
    my $config = shift;
    my $plugins = $config->{plugins} || [];

    my @plugin_list = ();
    my %plugin_args = ();

    for my $plugin ( @$plugins ) {
        if ( ref $plugin eq 'HASH' )  {
            my ($pkg) = keys %$plugin;
            push @plugin_list , $pkg ;
            $plugin_args{ $pkg } = $plugin->{$pkg};
        }
        else {
            push @plugin_list , $plugin; 
        }
    }

    $config->{plugins} = \@plugin_list;
    $config->{plugin} = \%plugin_args;
}

sub _substitute_config {
    my ( $class, $config ) = @_;

    my $v = Data::Visitor::Callback->new(
        plain_value => sub {
            return unless defined $_;
            $class->_config_substitutions($_);
        }
    );
    $v->visit($config);
}

sub validate_config {
    my ($class, $config, $schema) = @_;
    Polocky::Config::Validator->validate_config( $config, $schema );
}


sub _config_substitutions {
    my $class = shift;
    my $subs  = {};
    $subs->{home}    = sub { Polocky::Utils::home; };
    $subs->{path_to} = sub { Polocky::Utils::path_to(@_); };
    my $subsre = join( '|', keys %$subs );

    for (@_) {
        s{__($subsre)(?:\((.+?)\))?__}{ $subs->{ $1 }->( $2 ? split( /,/, $2 ) : () ) }eg;
    }
}

1;
