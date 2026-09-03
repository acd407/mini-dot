complete -c lxc-attach -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-attach -n __fish_use_subcommand -s e -l elevated-privileges -d "Use elevated privileges (CAP,CGROUP,LSM)"
complete -c lxc-attach -n __fish_use_subcommand -s a -l arch -d "Use ARCH for program"
complete -c lxc-attach -n __fish_use_subcommand -s s -l namespaces -d "Attach to specific namespaces (MOUNT,PID,UTSNAME,IPC,USER,NETWORK)"
complete -c lxc-attach -n __fish_use_subcommand -s R -l remount-sys-proc -d "Remount /sys and /proc"
complete -c lxc-attach -n __fish_use_subcommand -l clear-env -d "Clear all environment variables"
complete -c lxc-attach -n __fish_use_subcommand -l keep-env -d "Keep all environment variables"
complete -c lxc-attach -n __fish_use_subcommand -s L -l pty-log -d "Log pty output to FILE" -r
complete -c lxc-attach -n __fish_use_subcommand -s v -l set-var -d "Set additional environment variable"
complete -c lxc-attach -n __fish_use_subcommand -l keep-var -d "Keep additional environment variable"
complete -c lxc-attach -n __fish_use_subcommand -s f -l rcfile -d "Load configuration file" -r
complete -c lxc-attach -n __fish_use_subcommand -s u -l uid -d "Execute with UID inside container"
complete -c lxc-attach -n __fish_use_subcommand -s g -l gid -d "Execute with GID inside container"
complete -c lxc-attach -n __fish_use_subcommand -s c -l context -d "SELinux context"
complete -c lxc-attach -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-attach -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-attach -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-attach -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-attach -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-attach -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-attach -n __fish_use_subcommand -l version -d "Print version"
