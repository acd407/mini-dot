set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 8

set -g fish_greeting

# 确实应该优先导入系统的，后面在导入会让 fish 自己的配置失效
if status is-login
    set oldenv (mktemp)
    set newenv (mktemp)

    dash -c "
        export -p | sort >$oldenv
        set -a
        for f in \$HOME/.config/environment.d/*; do
            . \$f
        done
        set +a
        . /etc/profile
        export -p | sort >$newenv
    "

    for line in (comm -13 $oldenv $newenv | grep '^export ' | grep -v '^export LC_' | grep -v '^export LANG')
        set name (string replace -r '^export ([^=]+)=.*' '$1' -- $line)
        set value (string replace -r '^export [^=]+=(.*)' '$1' -- $line)

        if test "$name" = PATH
            set -l new_path_list (string split : -- (string unescape -- $value))
            fish_add_path --global --move --append --path $new_path_list
        else
            set -gx $name (string unescape -- $value)
        end

        if command -q systemctl
            systemctl --user import-environment $name
        end
    end

    rm -f $oldenv $newenv
end

for i in /{usr/{local/,},}{,s}bin
    if not contains $i $PATH; and test -d $i
        set -a PATH $i
    end
end

if status is-interactive
    if test -d $HOME/.bin
        fish_add_path --global --move --append --path $HOME/.bin
        if test -d $HOME/.bin/custom
            fish_add_path --global --move --append --path $HOME/.bin/custom
        end
        if test -n "$WAYLAND_DISPLAY"
            fish_add_path --global --move --append --path $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local/bin
        fish_add_path --global --move --append --path $HOME/.local/bin
    end
    if test -d /usr/lib/ccache
        fish_add_path --global --move --path /usr/lib/ccache
        if test -d /usr/lib/ccache/bin
            fish_add_path --global --move --path /usr/lib/ccache/bin
        end
    end
end
