set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 8

set -g fish_greeting

for i in /{usr/{local/,},}{,s}bin
    if not contains $i $PATH; and test -d $i
        fish_add_path -a $i
    end
end

if status is-interactive
    if test -d $HOME/.bin
        fish_add_path -a $HOME/.bin
        if test -d $HOME/.bin/custom
            fish_add_path -a $HOME/.bin/custom
        end
        if test -d $HOME/.bin/appimage
            fish_add_path -a $HOME/.bin/appimage
        end
        if test -n "$SWAYSOCK"
            fish_add_path -a $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local
        if test -d $HOME/.local/lib
            set -gx LD_LIBRARY_PATH $HOME/.local/lib
            if test -d $HOME/.local/lib/pkgconfig
                set -gx PKG_CONFIG_PATH $HOME/.local/lib/pkgconfig
            end
        end
        if test -d $HOME/.local/bin
            fish_add_path -a $HOME/.local/bin
        end
    end
    if test -d /usr/lib/ccache
        fish_add_path /usr/lib/ccache
        if test -d /usr/lib/ccache/bin
            fish_add_path /usr/lib/ccache/bin
        end
    end
    set -gx PIP_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    set -gx UV_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/pythonrc

    if command -v --quiet gpgconf
        set -e SSH_AGENT_PID
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end

    if test -n "$WAYLAND_DISPLAY"
        # 更新 TTY 信息，让 pinentry 弹出在正确的位置
        set -gx GPG_TTY (tty)
        gpg-connect-agent updatestartuptty /bye >/dev/null
    end

    if command -v --quiet abduco
        set -gx ABDUCO_SOCKET_DIR $XDG_DATA_HOME
    end

    if test "$TERM" = linux -o "$XDG_SESSION_TYPE" != x11 -a "$XDG_SESSION_TYPE" != wayland
        set -g fish_history disabled
        set -g fish_history_size 0
        set -g fish_history_path /dev/null
    else
        set -g fish_history_size 50000
        set -g fish_history_max_size 100000
    end
end
