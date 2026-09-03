complete -c lxc-destroy -n __fish_use_subcommand -xa "(__fish_lxc_containers)"
complete -c lxc-destroy -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-destroy -n __fish_use_subcommand -s s -l snapshots -d "Destroy including all snapshots"
complete -c lxc-destroy -n __fish_use_subcommand -s f -l force -d "Stop and destroy running container"
complete -c lxc-destroy -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-destroy -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-destroy -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-destroy -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-destroy -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-destroy -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-destroy -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-destroy -n __fish_use_subcommand -l version -d "Print version"
