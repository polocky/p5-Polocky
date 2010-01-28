package TestApp::App::Controller::Root;
use Polocky::Class;
BEGIN { extends 'Polocky::WAF::CatalystLike::Controller' };

__PACKAGE__->namespace('');

sub default : Path {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'not_found.tt';
}

sub end  :ActionClass('RenderView') {}

__POLOCKY__;
