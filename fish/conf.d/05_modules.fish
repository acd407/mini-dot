if status is-interactive
    if command -v --quiet npm
        if test -d $XDG_DATA_HOME/npm/bin
            fish_add_path --global --move --append --path $XDG_DATA_HOME/npm/bin
        end
    end
    if command -v --quiet pnpm
        if test -d $XDG_DATA_HOME/pnpm/bin
            fish_add_path --global --move --append --path $XDG_DATA_HOME/pnpm/bin
        end
    end
    if command -v --quiet cargo
        if test -d $HOME/.cargo/bin
            fish_add_path --global --move --append --path $HOME/.cargo/bin
        end
        set -gx RUSTUP_DIST_SERVER 'https://rsproxy.cn'
        set -gx RUSTUP_UPDATE_ROOT 'https://rsproxy.cn/rustup'
    end
    if command -v --quiet go
        set -gx GOPROXY 'https://goproxy.cn'
        set -gx GOPATH "$XDG_DATA_HOME/go"
        fish_add_path --global --move --append --path $GOPATH/bin
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

    if command -v --quiet dtach
        mkdir -p $XDG_STATE_HOME/dtach
    end

    if command -v --quiet firefox
        set -gx BROWSER firefox
    end

    set -gx HOMEBREW_BREW_GIT_REMOTE https://mirrors.ustc.edu.cn/brew.git
    set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles
    set -gx HOMEBREW_API_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles/api
    if test -f /home/linuxbrew/.linuxbrew/bin/brew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish | sed 's/fish_add_path/fish_add_path --append/')"
    end
end
