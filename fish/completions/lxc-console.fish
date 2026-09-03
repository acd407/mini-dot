complete -c lxc-console -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_running_containers)"
complete -c lxc-console -n __fish_use_subcommand -s t -l tty -d "Console tty number"
complete -c lxc-console -n __fish_use_subcommand -s e -l escape -d "Prefix for escape command"
complete -c lxc-console -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-console -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-console -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-console -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-console -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-console -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-console -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-console -n __fish_use_subcommand -l version -d "Print version"
