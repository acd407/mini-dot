if status is-interactive
    abbr -a -- l ls
    abbr -a -- ip 'ip -c -h'
    abbr -a -- sp speak
    abbr -a -- hx helix
    abbr -a -- sc systemctl
    abbr -a -- sct systemctl-tui
    abbr -a -- scu 'systemctl --user'
    abbr -a -- wcp wl-copy
    abbr -a -- pc 'pkg-config --cflags --libs'
    abbr -a -- df 'df -Th -x tmpfs'
    abbr -a -- sw 'systemctl --user start sway.service'

    if not command -v --quiet arp
        abbr -a -- arp 'cat /proc/net/arp'
    end
    if not command -v --quiet paru; and command -v --quiet pacman
        abbr -a -- paru pacman
    end

    if type -q nvim
        set -x EDITOR nvim
        set -x MANPAGER 'nvim +Man!'
    else if type -q vim
        set -x EDITOR vim
    else if type -q vis
        set -x EDITOR vis
    else if type -q helix
        set -x EDITOR helix
    else
        set -x EDITOR vi
    end
    abbr -a -- vi $EDITOR
end
