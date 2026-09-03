complete -c lxc-unshare -n __fish_use_subcommand -s s -l namespaces -d "ORed list of flags" -x -a "MOUNT PID UTSNAME IPC USER NETWORK"
complete -c lxc-unshare -n __fish_use_subcommand -s u -l user -d "New user id"
complete -c lxc-unshare -n __fish_use_subcommand -s H -l hostname -d "Set hostname in container"
complete -c lxc-unshare -n __fish_use_subcommand -s i -l ifname -d "Interface name to move into container"
complete -c lxc-unshare -n __fish_use_subcommand -s d -l daemon -d Daemonize
complete -c lxc-unshare -n __fish_use_subcommand -s M -l remount -d "Remount default fs inside container"
complete -c lxc-unshare -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-unshare -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-unshare -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-unshare -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-unshare -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-unshare -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-unshare -n __fish_use_subcommand -l version -d "Print version"
