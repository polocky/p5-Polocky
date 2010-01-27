+{
    default => {
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
        having => {
            'plugins' => ['TestApp::TestPlugin' ],
        },
        enginereq => {
            request_class => 'TestApp::Request'
        }

    }
};
