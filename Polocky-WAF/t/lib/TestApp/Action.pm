package TestApp::Action;
sub new { 
    my $class = shift;
    my $c = shift;
    bless { c => $c }, $class;
}

sub reverse {
    my$self = shift;
    return $self->{c}->req->request_uri;
}

1;
