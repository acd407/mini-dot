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

if status is-login
    set oldenv (mktemp)
    set newenv (mktemp)

    dash -c "
        export -p | sort >$oldenv
        set -a
        . $HOME/.config/environment.d/*
        set +a
        . /etc/profile
        export -p | sort >$newenv
    "

    for line in (comm -13 $oldenv $newenv | grep '^export ' | grep -v '^export LC_')
        set name (string replace -r '^export ([^=]+)=.*' '$1' -- $line)
        set value (string replace -r '^export [^=]+=(.*)' '$1' -- $line)

        set -gx $name (string unescape -- $value)

        if command -q systemctl
            systemctl --user import-environment $name
        end
    end

    rm -f $oldenv $newenv
end
