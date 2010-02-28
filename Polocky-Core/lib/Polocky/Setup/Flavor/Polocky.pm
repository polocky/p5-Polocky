package Polocky::Setup::Flavor::Polocky;
use strict;
use warnings;
use base 'Module::Setup::Flavor';
1;

=head1

Polocky::Setup::Flavor::Polocky - pack from polocky

=head1 SYNOPSIS

  Polocky::Setup::Flavor::Polocky-setup --init --flavor-class=+Polocky::Setup::Flavor::Polocky new_flavor

=cut

__DATA__

---
file: Changes
template: |
  Revision history for Perl extension [% module %]
  
  0.01    [% localtime %]
          - original version
---
file: MANIFEST.SKIP
template: |
  \bRCS\b
  \bCVS\b
  ^MANIFEST\.
  ^Makefile$
  ~$
  ^#
  \.old$
  ^blib/
  ^pm_to_blib
  ^MakeMaker-\d
  \.gz$
  \.cvsignore
  ^t/9\d_.*\.t
  ^t/perlcritic
  ^tools/
  \.svn/
  ^[^/]+\.yaml$
  ^[^/]+\.pl$
  ^\.shipit$
  ^\.git/
  \.sw[po]$
---
file: Makefile.PL
template: |
  use inc::Module::Install;
  name '[% dist %]';
  all_from 'lib/[% module_unix_path %].pm';
  
  # requires '';
  
  tests 't/*.t';
  author_tests 'xt';
  
  test_requires 'Test::More';
  test_requires 'Test::LoadAllModules';
  auto_include;
  WriteAll;
---
file: README
template: |
  This is Perl module [% module %].
  
  INSTALLATION
  
  [% module %] installation is straightforward. If your CPAN shell is set up,
  you should just be able to do
  
      % cpan [% module %]
  
  Download it, unpack it, then build it as per the usual:
  
      % perl Makefile.PL
      % make && make test
  
  Then install it:
  
      % make install
  
  DOCUMENTATION
  
  [% module %] documentation is available as in POD. So you can do:
  
      % perldoc [% module %]
  
  to read the documentation online with your favorite pager.
  
  [% config.author %]
---
file: bin/____var-polocky_appprefix-var____-helper
chmod: 0755
template: |
  [% polocky_startperl %]
  use warnings;
  use strict;
  use FindBin;
  use Path::Class;
  use lib Path::Class::Dir->new($FindBin::Bin, '..', 'lib')->stringify;
  
  my $type = shift @ARGV;
  my $helper = "Polocky::Setup::Helper::$type";
  eval "use $helper";
  if($@){die $@ };
  $helper->new(  options => { } , helper => { target => $ARGV[0] , appprefix => lc $ARGV[0] } )->run;
  
  =head1 NAME
  
  ./bin/[% cat_appprefix %]-helper App  Web
  
  =cut
---
file: xt/03_pod.t
template: |
  use Test::More;
  eval "use Test::Pod 1.00";
  plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
  all_pod_files_ok();
---
file: xt/02_perlcritic.t
template: |
  use strict;
  use Test::More;
  eval {
      require Test::Perl::Critic;
      Test::Perl::Critic->import( -profile => 'xt/perlcriticrc');
  };
  plan skip_all => "Test::Perl::Critic is not installed." if $@;
  all_critic_ok('lib');
---
file: xt/01_podspell.t
template: |
  use Test::More;
  eval q{ use Test::Spelling };
  plan skip_all => "Test::Spelling is not installed." if $@;
  add_stopwords(map { split /[\s\:\-]/ } <DATA>);
  $ENV{LANG} = 'C';
  all_pod_files_spelling_ok('lib');
  __DATA__
  [% config.author %]
  [% config.email %]
  [% module %]
---
file: xt/perlcriticrc
template: |
  [TestingAndDebugging::ProhibitNoStrict]
  allow=refs
---
file: conf/development_internal.pl
template: |
  +{
      default => {
          'logger' => {
              'dispatchers' => [
                  'screen'
                  ],
                  'screen' => {
                      'stderr' => '1',
                      'class' => 'Log::Dispatch::Screen',
                      'min_level' => 'debug'
                  }
          },
      }
  }
---
file: conf/config_schema.pl
template: |
  +{
      type => 'map',
      mapping => {
      }
  }
---
file: t/00_load_all.t
template: |+
  use strict;
  use warnings;
  use Test::LoadAllModules;
  
  BEGIN {
      all_uses_ok(
          search_path => '[% module %]',
      );
  }

---
file: lib/____var-module_path-var____.pm
template: |
  package [% module %];
  use strict;
  use warnings;
  our $VERSION = '0.01';
  
  1;
  __END__
  
  =head1 NAME
  
  [% module %] -
  
  =head1 SYNOPSIS
  
    use [% module %];
  
  =head1 DESCRIPTION
  
  [% module %] is
  
  =head1 AUTHOR
  
  [% config.author %] E<lt>[% config.email %]E<gt>
  
  =head1 SEE ALSO
  
  =cut
---
file: lib/____var-module_path-var____/Structure.pm
template: |+
  package [% module %]::Structure;
  use strict;
  use base qw(Polocky::Structure);
  1;

---
file: lib/____var-module_path-var____/Config.pm
template: |+
  package [% module %]::Config;
  use strict;
  use base qw(Polocky::Config);
  1;

---
file: lib/____var-module_path-var____/Logger.pm
template: |+
  package [% module %]::Logger;
  use strict;
  use base qw(Polocky::Logger);
  1;

---
config:
  class: Polocky::Setup::Flavor::Polocky
  plugins:
    - +Polocky::Setup::Plugin::Polocky
    - Config::Basic
    - Template
    - Test::Makefile
