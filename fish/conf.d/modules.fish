if status is-interactive
    if command -v --quiet npm
        if test -d $XDG_DATA_HOME/npm/bin
            fish_add_path -a $XDG_DATA_HOME/npm/bin
        end
        if test -d $HOME/node_modules/.bin
            fish_add_path -a $HOME/node_modules/.bin
        end
    end
    if command -v --quiet cargo
        if test -d $HOME/.cargo/bin
            fish_add_path -a $HOME/.cargo/bin
        end
        set -gx RUSTUP_DIST_SERVER 'https://rsproxy.cn'
        set -gx RUSTUP_UPDATE_ROOT 'https://rsproxy.cn/rustup'
    end
    if command -v --quiet go
        set -gx GOPROXY 'https://goproxy.cn'
        set -gx GOPATH "$XDG_DATA_HOME/go"
        fish_add_path -a $GOPATH/bin
    end
    if command -v --quiet vivid
        set -gx LS_COLORS (vivid generate one-dark)
    end
    if test "$TERM" = linux -o "$XDG_SESSION_TYPE" != x11 -a "$XDG_SESSION_TYPE" != wayland
        set -g fish_history disabled
        set -g fish_history_size 0
        set -g fish_history_path /dev/null
    else
        set -g fish_history_size 50000
        set -g fish_history_max_size 100000
    end

    set -gx PIP_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    set -gx UV_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/pythonrc
    set -gx PYTHON_HISTORY $XDG_STATE_HOME/python_history

    if command -v --quiet gpgconf
        set -e SSH_AGENT_PID
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end

    if test -n "$WAYLAND_DISPLAY"
        # 更新 TTY 信息，让 pinentry 弹出在正确的位置
        set -gx GPG_TTY (tty)
        gpg-connect-agent updatestartuptty /bye >/dev/null
    end

    if command -v --quiet firefox
        set -gx BROWSER firefox
    end

    set -gx PNPM_HOME "/home/acd407/.local/share/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
end
