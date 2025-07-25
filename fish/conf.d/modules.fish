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
        set -gx GOPROXY 'https://goproxy.io'
        set -gx GOPATH "$XDG_DATA_HOME/go"
        fish_add_path -a $GOPATH/bin
    end
    if command -v --quiet vivid
        set -gx LS_COLORS (vivid generate one-dark)
    end
end
