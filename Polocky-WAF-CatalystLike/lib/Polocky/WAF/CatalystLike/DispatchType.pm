package Polocky::WAF::CatalystLike::DispatchType;

use Polocky::Class;

sub list { }

sub match { die "Abstract method!" }

sub register { }

sub uri_for_action { }

sub expand_action { }

sub _is_low_precedence { 0 }

__POLOCKY__

__END__
