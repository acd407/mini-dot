if status is-interactive
    if test -d $HOME/.bin
        set -a PATH $HOME/.bin
        if test -d $HOME/.bin/custom
            set -a PATH $HOME/.bin/custom
        end
        if test -n "$SWAYSOCK"
            set -a PATH $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local/bin
        set -a PATH $HOME/.local/bin
    end
    if test -d /usr/lib/ccache/bin/
        set -p PATH /usr/lib/ccache/bin/
    end
    if command -v --quiet npm
        if test -d $XDG_DATA_HOME/npm/bin
            set -a PATH $XDG_DATA_HOME/npm/bin
        end
        if test -d $HOME/node_modules/.bin
            set -a PATH $HOME/node_modules/.bin
        end
    end
    if command -v --quiet cargo
        if test -d $HOME/.cargo/bin
            set -a PATH $HOME/.cargo/bin
        end
        set -gx RUSTUP_DIST_SERVER 'https://rsproxy.cn'
        set -gx RUSTUP_UPDATE_ROOT 'https://rsproxy.cn/rustup'
    end
    if command -v --quiet go
        set -gx GOPROXY 'https://goproxy.io'
        set -gx GOPATH "$HOME/.cache/go"
    end
    if command -v --quiet vf
        set -gx VIRTUALFISH_HOME $PWD/.local/share/venv
    end
    if command -v --quiet vivid
        set -gx LS_COLORS (vivid generate one-dark)
    end
end
