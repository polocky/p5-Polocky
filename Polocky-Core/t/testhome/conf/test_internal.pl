+{
    application => {
        config => {
            plugins => [
                'Hoge',
            { AAA => { A => 1 } },
            ],
            pkg => {
                'B' => 'DDD',
            },
            'logger' => {
                'dispatchers' => [
                    'screen'
                    ],
                'screen' => {
                    'stderr' => '1',
                    'class' => 'Log::Dispatch::Screen',
                    'min_level' => 'debug'
                }
            },
        },
               mid => {
                   middlewares => [ 'Foo', 'Bar' ],
                   'logger' => {
                       'dispatchers' => [
                           'screen'
                           ],
                       'screen' => {
                           'stderr' => '1',
                           'class' => 'Log::Dispatch::Screen',
                           'min_level' => 'debug'
                       }
                   },
               },
    },
    default => {
        'pkg' => {
            'A' => 'AAA',
            'B' => 'XXX',
            'C' => undef,
        },
        'only_default' => {
            'A' => 1,    
        }
    }
}
