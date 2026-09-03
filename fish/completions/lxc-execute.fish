complete -c lxc-execute -n __fish_use_subcommand -s n -l name -d "NAME of the container"
complete -c lxc-execute -n __fish_use_subcommand -s d -l daemon -d "Daemonize the container"
complete -c lxc-execute -n __fish_use_subcommand -s f -l rcfile -d "Load configuration file" -r
complete -c lxc-execute -n __fish_use_subcommand -s s -l define -d "Assign VAL to configuration variable KEY"
complete -c lxc-execute -n __fish_use_subcommand -s u -l uid -d "Execute with UID inside container"
complete -c lxc-execute -n __fish_use_subcommand -s g -l gid -d "Execute with GID inside container"
complete -c lxc-execute -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-execute -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-execute -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-execute -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-execute -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-execute -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-execute -n __fish_use_subcommand -l version -d "Print version"
