if status is-login
    set -l oldenv (mktemp -p "$PREFIX/tmp" env.old.XXXXXX)
    set -l newenv (mktemp -p "$PREFIX/tmp" env.new.XXXXXX)

    dash -c '
    export -p | sort >"'$oldenv'"
    . ~/.config/environment.d/* >/dev/null 2>&1
    . /etc/profile >/dev/null 2>&1
    export -p | sort >"'$newenv'"
    '

    set -l etc_envs (comm -13 $oldenv $newenv | grep -v '^export LC_')

    set -l etc_envs_keys
    for line in $etc_envs
        set -l var_name (string replace -r '^export ([^=]+).*' '$1' -- $line)
        set -a etc_envs_keys $var_name
    end

    if set -q etc_envs_keys[1]
        eval $etc_envs
        if command -v --quiet systemctl
            systemctl --user import-environment $etc_envs_keys
        end
    end

    rm -f $oldenv $newenv
end

set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 8

set -g fish_greeting

for i in /{usr/{local/,},}{,s}bin
    if not contains $i $PATH; and test -d $i
        set -a PATH $i
    end
end

if status is-interactive
    if test -d $HOME/.bin
        set -a PATH $HOME/.bin
        if test -d $HOME/.bin/custom
            set -a PATH $HOME/.bin/custom
        end
        if test -d $HOME/.bin/appimage
            set -a PATH $HOME/.bin/appimage
        end
        if test -n "$WAYLAND_DISPLAY"
            set -a PATH $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local/bin
        set -a PATH $HOME/.local/bin
    end
    if test -d /usr/lib/ccache
        set -p PATH /usr/lib/ccache
        if test -d /usr/lib/ccache/bin
            set -p PATH /usr/lib/ccache/bin
        end
    end
end
