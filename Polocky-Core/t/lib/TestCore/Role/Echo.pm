package TestCore::Role::Echo;
use Polocky::Role;

sub echo {
    shift;
    return shift;
}


1;
