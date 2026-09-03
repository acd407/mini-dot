complete -c lxc-create -n __fish_use_subcommand -s n -l name -d "NAME of the container"
complete -c lxc-create -n __fish_use_subcommand -s f -l config -d "Initial configuration file" -r
complete -c lxc-create -n __fish_use_subcommand -s t -l template -d "Template to use" -xa "(lxc-create -t help | string match -r '^[a-z]+')"
complete -c lxc-create -n __fish_use_subcommand -s B -l bdev -d "Backing store type" -x -a "dir lvm loop btrfs overlayfs zfs rbd"
complete -c lxc-create -n __fish_use_subcommand -l dir -d "Place rootfs directory under DIR" -r
complete -c lxc-create -n __fish_use_subcommand -l lvname -d "Use LVM lv name" -r
complete -c lxc-create -n __fish_use_subcommand -l vgname -d "Use LVM vg name" -r
complete -c lxc-create -n __fish_use_subcommand -l thinpool -d "Use LVM thin pool" -r
complete -c lxc-create -n __fish_use_subcommand -l rbdname -d "Use Ceph RBD name" -r
complete -c lxc-create -n __fish_use_subcommand -l rbdpool -d "Use Ceph RBD pool name" -r
complete -c lxc-create -n __fish_use_subcommand -l zfsroot -d "Create zfs under given zfsroot" -r
complete -c lxc-create -n __fish_use_subcommand -l fstype -d "Create filesystem type" -x -a "ext4 xfs btrfs"
complete -c lxc-create -n __fish_use_subcommand -l fssize -d "Create filesystem size"
complete -c lxc-create -n __fish_use_subcommand -s o -l logfile -d "Output log to FILE" -r
complete -c lxc-create -n __fish_use_subcommand -s l -l logpriority -d "Set log priority" -x -a "DEBUG INFO NOTICE WARN ERROR CRIT ALERT EMERG"
complete -c lxc-create -n __fish_use_subcommand -s q -l quiet -d "Don't produce any output"
complete -c lxc-create -n __fish_use_subcommand -s P -l lxcpath -d "Use specified container path" -r
complete -c lxc-create -n __fish_use_subcommand -s '?' -l help -d "Show help"
complete -c lxc-create -n __fish_use_subcommand -l usage -d "Show short usage"
complete -c lxc-create -n __fish_use_subcommand -l version -d "Print version"
