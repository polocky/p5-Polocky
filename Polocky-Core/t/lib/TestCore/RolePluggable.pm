package TestCore::RolePluggable;
use Polocky::Class;
with 'Polocky::Role::Pluggable';

sub setup {
    my $self = shift;
    $self->load_plugin( 'TestCore::Role::Echo' );  
}
sub err01 {
    my $self = shift;
    $self->load_plugin();
}

sub err02 {
    my $self = shift;
    $self->load_plugin('LOLERRRRRR');
}

__POLOCKY__ ;

