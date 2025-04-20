set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 4

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
        if test -n "$SWAYSOCK"
            fish_add_path -a $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local/bin
        fish_add_path -a $HOME/.local/bin
    end
    if test -d /usr/lib/ccache/bin
        fish_add_path /usr/lib/ccache/bin
    end
    set -gx PIP_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    set -gx UV_INDEX_URL https://pypi.mirrors.ustc.edu.cn/simple
    bass source /etc/profile
end
