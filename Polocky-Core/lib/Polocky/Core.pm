package Polocky::Core;
use Polocky::Class;

our $VERSION = '0.03';

with 'Polocky::Role::Configurable';
with 'Polocky::Role::Pluggable';
with 'Polocky::Role::Logger';
with 'Polocky::Role::ClassData';

# I name this class as core but it's does not mean I like hardcore Porn.

__POLOCKY__ ;

=head1 NAME

Polocky::Core - Polocky's core is fire on his head.

=head1 SYNOPSIS

 package YourClass;
 use Polocky::Class;
 extends 'Polocky::Core';
 __PACKAGE__->mk_classdata('lol');

 sub hoge {
    my $self   = shift;
    my $config = $self->config;
    $self->load_plugin('He');
    $self->logger->debug('hi');
 }

 __POLOCKY__ ;

=head1 DESCRIPTION

use this , make us happy.

=head1 SEE ALSO

L<Polocky::Role::Configurable>
L<Polocky::Role::Pluggable>
L<Polocky::Role::Logger>
L<Polocky::Role::ClassData>

=head1 AUTHOR

polocky

=cut
