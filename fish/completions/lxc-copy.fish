complete -c lxc-copy -n __fish_use_subcommand -s n -l name -d "NAME of the container" -xa "(__fish_lxc_containers)"
complete -c lxc-copy -n __fish_use_subcommand -s N -l newname -d "NEWNAME for the container"
complete -c lxc-copy -n __fish_use_subcommand -s p -l newpath -d "NEWPATH for the container" -r
complete -c lxc-copy -n __fish_use_subcommand -s R -l rename -d "Rename container"
complete -c lxc-copy -n __fish_use_subcommand -s s -l snapshot -d "Create snapshot instead of clone"
complete -c lxc-copy -n __fish_use_subcommand -s a -l allowrunning -d "Allow snapshot of running container"
complete -c lxc-copy -n __fish_use_subcommand -s F -l foreground -d "Start with tty attached"
complete -c lxc-copy -n __fish_use_subcommand -s d -l daemon -d "Daemonize the container"
complete -c lxc-copy -n __fish_use_subcommand -s e -l ephemeral -d "Start ephemeral container"
complete -c lxc-copy -n __fish_use_subcommand -s m -l mount -d "Directory to mount into container"
complete -c lxc-copy -n __fish_use_subcommand -s B -l backingstorage -d "Backingstorage type" -x -a "dir lvm loop btrfs overlay zfs"
complete -c lxc-copy -n __fish_use_subcommand -s t -l tmpfs -d "Place ephemeral container on tmpfs"
complete -c lxc-copy -n __fish_use_subcommand -s L -l fssize -d "Size of new block device"
complete -c lxc-copy -n __fish_use_subcommand -s D -l keepdata -d "Start persistent snapshot"
complete -c lxc-copy -n __fish_use_subcommand -s K -l keepname -d "Keep hostname of original"
complete -c lxc-copy -n __fish_use_subcommand -s M -l keepmac -d "Keep MAC address of original"
complete -c lxc-copy -n __fish_use_subcommand -l rcfile -d "Load configuration file" -r
complete -c lxc-copy -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-copy -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-copy -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-copy -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-copy -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-copy -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-copy -n __fish_use_subcommand -l version -d "Print version"
