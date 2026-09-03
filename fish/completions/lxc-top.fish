complete -c lxc-top -n __fish_use_subcommand -s d -l delay -d "Delay between refreshes"
complete -c lxc-top -n __fish_use_subcommand -s b -l batch -d "Output for capture to file"
complete -c lxc-top -n __fish_use_subcommand -s s -l sort -d "Sort by column" -x -a "n c b m s k"
complete -c lxc-top -n __fish_use_subcommand -s r -l reverse -d "Sort in reverse order"
complete -c lxc-top -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-top -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-top -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-top -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-top -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-top -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-top -n __fish_use_subcommand -l version -d "Print version"
