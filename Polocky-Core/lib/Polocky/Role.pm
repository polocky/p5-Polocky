package Polocky::Role;
use strict;
use warnings;
use Moose::Role ();
 
sub import {
    goto &Moose::Role::import;
}
          
1;
