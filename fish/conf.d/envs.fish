set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 4

set -g fish_greeting
