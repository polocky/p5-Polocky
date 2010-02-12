package Polocky::Setup::Helper::Script;
use strict;
use warnings;
use base 'Polocky::Setup::Helper';
sub generate_path_option_names { qw/ target / }
sub is_append_files { 1 } # append type helper

1;

__DATA__

---
file: bin/____var-polocky_appprefix-var____
chmod: 0755
template: |
    [% polocky_startperl %]
    BEGIN {
        use FindBin;
        use File::Spec;
        my $HOME = $FindBin::Bin .'/../';
        $ENV{POLOCKY_HOME} = $HOME;
    };
    
    use warnings;
    use strict;
    use FindBin::libs;
    use Polocky::Util::Initializer '[% module %]::[% polocky_target %]';
    use [% module %]::[% polocky_target %];
    [% module %]::[% polocky_target %]->run();
---
file: lib/____var-module_path-var____/____var-polocky_target_path-var____.pm
template: |
    package [% module %]::[% polocky_target %];
    use Polocky::Class;
    extends qw(Polocky::Script);
    use constant plugin_search_path => __PACKAGE__;
    __POLOCKY__;
---
file: lib/____var-module_path-var____/____var-polocky_target_path-var____/sample.pm
template: |
    package [% module %]::[% polocky_target %]::sample;
    use Polocky::Class;
    extends 'Polocky::Script::Base';
    
    has 'name' =>(
        is => 'rw',
        default => 'polocky',
        isa => 'Str',
    );

    sub execute {
        my $self = shift ;
        print "Hi," . $self->name ."!\n";
    }
    
    __POLOCKY__;
---
config:
  class: Polocky::Setup::Flavor::Polocky
  plugins:
    - +Polocky::Setup::Plugin::Polocky
