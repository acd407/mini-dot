complete -c lxc-checkpoint -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_running_containers)"
complete -c lxc-checkpoint -n __fish_use_subcommand -s r -l restore -d "Restore container"
complete -c lxc-checkpoint -n __fish_use_subcommand -s D -l checkpoint-dir -d "Directory to save checkpoint" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s v -l verbose -d "Enable verbose criu logs"
complete -c lxc-checkpoint -n __fish_use_subcommand -s A -l action-script -d "Path to criu action script" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s s -l stop -d "Stop container after checkpointing"
complete -c lxc-checkpoint -n __fish_use_subcommand -s p -l pre-dump -d "Only pre-dump memory"
complete -c lxc-checkpoint -n __fish_use_subcommand -l predump-dir -d "Path to images from previous dump" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s d -l daemon -d "Daemonize the container"
complete -c lxc-checkpoint -n __fish_use_subcommand -s F -l foreground -d "Start with tty attached"
complete -c lxc-checkpoint -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-checkpoint -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-checkpoint -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-checkpoint -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-checkpoint -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-checkpoint -n __fish_use_subcommand -l version -d "Print version"
