if status is-interactive
    abbr -a -- l ls
    abbr -a -- ip 'ip -c -h -d'
    abbr -a -- sp speak
    abbr -a -- hx helix
    abbr -a -- sc systemctl
    abbr -a -- scu 'systemctl --user'
    abbr -a -- wcp wl-copy
    abbr -a -- pc 'pkg-config --cflags --libs'
    abbr -a -- df 'df -Th -x tmpfs'
    abbr -a -- img chafa
    abbr -a -- yz yazi
    abbr -a -- ping 'ping -n'
    abbr -a -- base16 'xxd -ps'
    abbr -a -- flatpak 'flatpak --user'
    abbr -a -- tlmgr 'tlmgr --usermode'
    abbr -a -- ni niri-session
    abbr -a -- relock "env (cat /proc/(pidof hypridle)/environ | tr '\0' '\n' | rg '^(SWAYSOCK|WAYLAND_DISPLAY)') ~/.bin/wm/lock"

    if not command -v --quiet arp
        abbr -a -- arp 'cat /proc/net/arp'
    end
    if not command -v --quiet paru; and command -v --quiet pacman
        abbr -a -- paru pacman
    end

    # Find the best available editor
    set -l real_editor
    if type -q vi
        if test -L (which vi)
            set real_editor (basename (readlink (which vi)))
        else
            set real_editor vi
        end
    else
        for e in nvim vim vis
            if type -q $e
                set real_editor $e
                break
            end
        end
    end

    # Set editor and manpager
    if test -n "$real_editor"
        switch $real_editor
            case nvim
                set -x EDITOR nvim
                set -x MANPAGER 'nvim +Man!'
            case '*'
                set -x EDITOR $real_editor
        end
        abbr -a -- vi $EDITOR
    end
end
