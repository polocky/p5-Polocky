use Test::Most qw/no_plan/;
use_ok( 'Polocky::Config::Validator') ;
ok(Polocky::Config::Validator->validate_config( { a => 'a' } , { type => 'map' , mapping => { a => { type => 'any'} }} ) );
throws_ok { Polocky::Config::Validator->validate_config( { b => 'a' } , { type => 'map' , mapping => { a => { type => 'any'} }} )  }  qr/^config validation/;
