+{
    logger => {
        dispatchers => ['screen'],
        screen => {
            class => 'Log::Dispatch::Screen',
            min_level =>'debug', 
            stderr => 1,
            format => "%m\n"
        },
    },
    polocky => {
        view => {
            plugins  => [],
        }
    }
}
