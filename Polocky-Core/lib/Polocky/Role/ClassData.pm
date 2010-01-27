package Polocky::Role::ClassData;

use Moose::Role;
use Moose::Meta::Class ();
use Class::MOP;
use Moose::Util ();
use Polocky::Exceptions;

sub mk_classdata {
  my ($class, $attribute) = @_;
  Polocky::Exception::NotAcceptable->throw("mk_classdata() is a class method, not an object method") if blessed $class;

  my $slot = '$'.$attribute;
  my $accessor =  sub {
    my $pkg = ref $_[0] || $_[0];
    my $meta = Moose::Util::find_meta($pkg)
        || Moose::Meta::Class->initialize( $pkg );
    if (@_ > 1) {
      $meta->namespace->{$attribute} = \$_[1];
      return $_[1];
    }

    no strict 'refs';
    my $v = *{"${pkg}::${attribute}"}{SCALAR};
    if (defined ${$v}) {
     return ${$v};
    } else {
      foreach my $super ( $meta->linearized_isa ) {
        my $v = ${"${super}::"}{$attribute} ? *{"${super}::${attribute}"}{SCALAR} : undef;
        if (defined ${$v}) {
          return ${$v};
        }
      }
    }
    return;
  };

  confess("Failed to create accessor: $@ ")
    unless ref $accessor eq 'CODE';

  my $meta = $class->Class::MOP::Object::meta();
  confess "${class}'s metaclass is not a Class::MOP::Class"
    unless $meta->isa('Class::MOP::Class');

  my $was_immutable = $meta->is_immutable;
  $meta->make_mutable if $was_immutable;

  my $alias = "_${attribute}_accessor";
  $meta->add_method($alias, $accessor);
  $meta->add_method($attribute, $accessor);

  $meta->make_immutable if $was_immutable;

  $class->$attribute($_[2]) if(@_ > 2);
  return $accessor;
}

1;

=head1 NAME

Polocky::Role::ClassData - like Class::Data::Inheritable

=head1 SYNOPSIS

 package Foo;
 __PACKAGE__->mk_classdata('hoge');


=head1 DESCRIPTION

this code steal from Catalyst::ClassData and implement as Role.

=head1 AUTHOR

polocky

=cut
