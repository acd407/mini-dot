set -l CPU_COUNT (nproc)
set -gx MAKEFLAGS "-j$CPU_COUNT"
set -gx OPENBLAS_NUM_THREADS $CPU_COUNT
set -gx CMAKE_BUILD_PARALLEL_LEVEL 8

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
        if test -d $HOME/.bin/appimage
            fish_add_path -a $HOME/.bin/appimage
        end
        if test -n "$SWAYSOCK"
            fish_add_path -a $HOME/.bin/wm
        end
    end
    if test -d $HOME/.local/bin
        fish_add_path -a $HOME/.local/bin
    end
    if test -d /usr/lib/ccache
        fish_add_path /usr/lib/ccache
        if test -d /usr/lib/ccache/bin
            fish_add_path /usr/lib/ccache/bin
        end
    end
end

# source /etc/profile with dash
if status is-login
    # ========== 第一部分：/etc/profile → shell → systemd ==========
    set -l oldenv (mktemp -p "$PREFIX/tmp" env.old.XXXXXX)
    set -l newenv (mktemp -p "$PREFIX/tmp" env.new.XXXXXX)

    dash -c '
    export -p | sort >"'$oldenv'"
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

    # ========== 第二部分：systemd → shell (跳过只读变量) ==========
    if command -v --quiet systemctl
        # 定义不应覆盖的变量（支持正则匹配）
        set -l readonly_patterns \
            '^PATH$' '^HOME$' '^USER$' '^LOGNAME$' '^SHELL$' \
            '^PWD$' '^OLDPWD$' '^SHLVL$' '^_$' \
            '^LANG$' '^LC_' \
            '^XDG_SESSION_' '^XDG_RUNTIME_DIR$' '^XDG_CURRENT_DESKTOP$' \
            '^DBUS_SESSION_BUS_ADDRESS$' \
            '^DISPLAY$' '^XAUTHORITY$' \
            '^TERM$' '^SESSION_MANAGER$' '^DESKTOP_SESSION$' '^GDMSESSION$' \
            '^SSH_AUTH_SOCK$' '^SSH_AGENT_PID$' '^SSH_CONNECTION$' '^SSH_CLIENT$'

        # 遍历 systemd 环境变量
        for line in (systemctl --user show-environment 2>/dev/null)
            if test -n "$line"
                set -l var_name (string split -m 1 '=' -- $line)[1]
                set -l var_value (string split -m 1 '=' -- $line)[2]

                # 检查是否匹配只读模式
                set -l is_readonly false
                for pattern in $readonly_patterns
                    if string match -qr -- $pattern $var_name
                        set is_readonly true
                        break
                    end
                end

                if test $is_readonly = true
                    continue
                end

                # 跳过已在 fish 中存在的变量
                if set -q $var_name
                    continue
                end

                # 设置环境变量
                set -gx $var_name $var_value
            end
        end
    end
end
