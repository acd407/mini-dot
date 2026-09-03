complete -c lxc-stop -n "__fish_use_subcommand" -xa "(__fish_lxc_running_containers)"
complete -c lxc-stop -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_running_containers)"
complete -c lxc-stop -n __fish_use_subcommand -s r -l reboot -d "Reboot the container"
complete -c lxc-stop -n __fish_use_subcommand -s W -l nowait -d "Don't wait for shutdown"
complete -c lxc-stop -n __fish_use_subcommand -s t -l timeout -d "Wait T seconds before hard-stopping"
complete -c lxc-stop -n __fish_use_subcommand -s k -l kill -d "Kill container"
complete -c lxc-stop -n __fish_use_subcommand -l nolock -d "Avoid using API locks"
complete -c lxc-stop -n __fish_use_subcommand -l nokill -d "Only request clean shutdown"
complete -c lxc-stop -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-stop -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-stop -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-stop -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-stop -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-stop -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-stop -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-stop -n __fish_use_subcommand -l version -d "Print version"
