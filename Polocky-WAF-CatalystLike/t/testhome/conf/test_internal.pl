+{
    default => {
        view => 'TT',
    plugins => [
    #    'Polocky::WAF::CatalystLike::Plugin::ShowDispatcher'  
        'TestApp::Plugin::Echo',
    ],
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
    application =>{
    }
};
