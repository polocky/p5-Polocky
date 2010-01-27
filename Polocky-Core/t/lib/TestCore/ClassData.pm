package TestCore::ClassData;
use Polocky::Class;
with 'Polocky::Role::ClassData';

__PACKAGE__->mk_classdata( 'a' );
__PACKAGE__->a( 'A' );
__PACKAGE__->mk_classdata( 'b' => 'hehe'  );

sub err01 {
    my $self = shift; 
    $self->mk_classdata('hoge');
}


__POLOCKY__ ;
