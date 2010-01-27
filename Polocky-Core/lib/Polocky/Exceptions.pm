package Polocky::Exceptions;
use strict;
use warnings;
my %E;

BEGIN {
    %E = (
        'Polocky::Exception' =>
            { description => 'Generic excepction for Polocky' },
        'Polocky::Exception::ClassNotFound' => {
            description => 'This class Not Found'
        },
        'Polocky::Exception::AbstractMethod' => {
            description => 'This method is Abstract'
        },
        'Polocky::Exception::UnimplementedMethod' => {
            description => 'This method is unimplemented'
        },
        'Polocky::Exception::DeprecatedMethod' => {
            description => 'This method is deprecated'
        },

        'Polocky::Exception::InvalidArgumentError' => {
            description => 'Argument type mismatch'
        },

        'Polocky::Exception::TemplateNotFound' => {
            description => 'Template cannot open template file'
        },

        'Polocky::Exception::NotAcceptable' => {
            description => 'This isnt acceptable'
        },

        'Polocky::Exception::FileNotFound' => {
            description => 'file not found error'
        },

        'Polocky::Exception::ParameterMissingError' => {
            description => 'parameter is missing'
        },

        'Polocky::Exception::ComponentNotFound' => {
            description => 'Component (MVC) not found'
        },

        'Polocky::Exception::Detach' => {
            description => 'detach'
        },

    );
}

use Exception::Class (%E);

BEGIN {
    $Exception::Class::BASE_EXC_CLASS = 'Polocky::Exception';
}
# trace mode on
$_->Trace(1) for keys %E;

1;
