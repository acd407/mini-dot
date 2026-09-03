complete -c lxc-info -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-info -n __fish_use_subcommand -s c -l config -d "Show configuration variable KEY"
complete -c lxc-info -n __fish_use_subcommand -s i -l ips -d "Show IP addresses"
complete -c lxc-info -n __fish_use_subcommand -s p -l pid -d "Show process id of init"
complete -c lxc-info -n __fish_use_subcommand -s S -l stats -d "Show usage stats"
complete -c lxc-info -n __fish_use_subcommand -s H -l no-humanize -d "Show raw numbers"
complete -c lxc-info -n __fish_use_subcommand -s s -l state -d "Show state of container"
complete -c lxc-info -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-info -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-info -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-info -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-info -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-info -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-info -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-info -n __fish_use_subcommand -l version -d "Print version"
