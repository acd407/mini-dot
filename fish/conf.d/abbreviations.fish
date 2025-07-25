if status is-interactive
    abbr -a -- l ls
    abbr -a -- ip 'ip -c -h -d'
    abbr -a -- sp speak
    abbr -a -- hx helix
    abbr -a -- sc systemctl
    abbr -a -- sct systemctl-tui
    abbr -a -- scu 'systemctl --user'
    abbr -a -- wcp wl-copy
    abbr -a -- pc 'pkg-config --cflags --libs'
    abbr -a -- df 'df -Th -x tmpfs'
    abbr -a -- uw 'uwsm start default'
    abbr -a -- sw 'uwsm start sway'
    abbr -a -- hy 'uwsm start hyprland'
    abbr -a -- relock "env (cat /proc/(pidof hypridle)/environ | tr '\0' '\n' | rg '^(SWAYSOCK|WAYLAND_DISPLAY)') ~/.bin/wm/lock"
    abbr -a -- img chafa
    abbr -a -- yz yazi
    abbr -a -- ping 'ping -n'
    abbr -a -- lxc-ls 'lxc-ls -q'
    abbr -a -- lxc-info 'lxc-info -q'
    abbr -a -- base16 'xxd -ps'
    abbr -a -- flatpak 'flatpak --user'
    abbr -a -- tlmgr 'tlmgr --usermode'

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
