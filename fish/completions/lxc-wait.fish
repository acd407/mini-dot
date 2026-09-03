complete -c lxc-wait -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-wait -n __fish_use_subcommand -s s -l state -d "States to wait for" -x -a "STOPPED STARTING RUNNING STOPPING ABORTING FREEZING FROZEN THAWED"
complete -c lxc-wait -n __fish_use_subcommand -s t -l timeout -d "Seconds to wait"
complete -c lxc-wait -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-wait -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-wait -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-wait -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-wait -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-wait -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-wait -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-wait -n __fish_use_subcommand -l version -d "Print version"
