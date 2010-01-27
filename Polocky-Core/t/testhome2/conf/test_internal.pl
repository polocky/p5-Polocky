+{
    application => { },
    default => {
        x => {
            'A' => 'AAA',
            'B' => 'XXX',
        },
        'logger' => {
            'dispatchers' => [
                'screen'
                ],
            'screen' => {
                'format' => '%m
                    ',
                'stderr' => '1',
                'class' => 'Log::Dispatch::Screen',
                'min_level' => 'debug'
            }
        },
    }
}
