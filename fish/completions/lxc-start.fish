complete -c lxc-start -n __fish_use_subcommand -xa "(__fish_lxc_containers)"
complete -c lxc-start -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-start -n __fish_use_subcommand -s d -l daemon -d "Daemonize the container"
complete -c lxc-start -n __fish_use_subcommand -s F -l foreground -d "Start with tty attached"
complete -c lxc-start -n __fish_use_subcommand -s p -l pidfile -d "Create file with process id" -r
complete -c lxc-start -n __fish_use_subcommand -s f -l rcfile -d "Load configuration file" -r
complete -c lxc-start -n __fish_use_subcommand -s c -l console -d "Use FILE for console" -r
complete -c lxc-start -n __fish_use_subcommand -s L -l console-log -d "Log console output to FILE" -r
complete -c lxc-start -n __fish_use_subcommand -s C -l close-all-fds -d "Close all inherited fds"
complete -c lxc-start -n __fish_use_subcommand -s s -l define -d "Assign VAL to configuration variable KEY"
complete -c lxc-start -n __fish_use_subcommand -l share-net -d "Share network namespace"
complete -c lxc-start -n __fish_use_subcommand -l share-ipc -d "Share IPC namespace"
complete -c lxc-start -n __fish_use_subcommand -l share-uts -d "Share UTS namespace"
complete -c lxc-start -n __fish_use_subcommand -l share-pid -d "Share PID namespace"
complete -c lxc-start -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-start -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-start -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-start -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-start -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-start -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-start -n __fish_use_subcommand -l version -d "Print version"
