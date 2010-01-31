package Polocky::Setup::Helper::WAF::Simple;
use strict;
use warnings;
use base 'Polocky::Setup::Helper';
sub generate_path_option_names { qw/ target / }
sub is_append_files { 1 } # append type helper

1;

__DATA__

---
file: etc/____var-polocky_appprefix-var____.psgi
template: |
  use warnings;
  use strict;
  use FindBin;
  use Path::Class;
  use lib Path::Class::Dir->new($FindBin::Bin, '..', 'lib')->stringify;
  use [% module %]::[% polocky_target %];
  my $app = [% module %]::[% polocky_target %]->new;
  my $handler = $app->psgi_handler ;
---
file: lib/____var-module_path-var____/____var-polocky_target_path-var____.pm
template: |
  package [% module %]::[% polocky_target %];
  use Polocky::Class;
  use Polocky::Util::Initializer '[% module %]::[% polocky_target %]';
  extends 'Polocky::WAF::Simple';
  
  sub handle_request {
    my ( $self , $c ) = @_;
    $c->res->body('Hello [% module %]::[% polocky_target %]');
    $c->res->content_type('text/html');
    $c->res->code( 200 );
  }
  __POLOCKY__;
