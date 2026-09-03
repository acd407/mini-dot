complete -c lxc-snapshot -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-snapshot -n __fish_use_subcommand -s L -l list -d "List all snapshots"
complete -c lxc-snapshot -n __fish_use_subcommand -s r -l restore -d "Restore snapshot NAME"
complete -c lxc-snapshot -n __fish_use_subcommand -s N -l newname -d "NEWNAME for restored container"
complete -c lxc-snapshot -n __fish_use_subcommand -s d -l destroy -d "Destroy snapshot NAME"
complete -c lxc-snapshot -n __fish_use_subcommand -s c -l comment -d "Add FILE as comment" -r
complete -c lxc-snapshot -n __fish_use_subcommand -s C -l showcomments -d "Show snapshot comments"
complete -c lxc-snapshot -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-snapshot -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-snapshot -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-snapshot -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-snapshot -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-snapshot -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-snapshot -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-snapshot -n __fish_use_subcommand -l version -d "Print version"
