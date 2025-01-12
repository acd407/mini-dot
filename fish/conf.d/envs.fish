set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 4

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
end
