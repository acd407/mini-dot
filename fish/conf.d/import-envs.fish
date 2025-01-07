function setvar
    set -l envs
    sort | uniq | while read line
        set key (echo $line | cut -d '=' -f 1)
        set value (echo $line | cut -d '=' -f 2-)
        # 检查变量是否为只读变量
        switch $key
            case PWD SHLVL _
                # 如果是只读变量，不进行操作
                continue
            case '*'
                # 如果不是只读变量，设置该环境变量
                set -gx "$key" $value
                set -a envs $key
        end
    end
    if command -v --quiet systemctl; and test "$argv[1]" = -x
        systemctl --user import-environment $envs
    end
end

if status is-login
    if command -v --quiet bash
        bash -c "env -i comm -13 <(env | sort) <(source $PREFIX/etc/profile && env | sort) 2>/dev/null" | setvar -x
    end
    if command -v --quiet systemctl; and not test -L (command -v systemctl)
        systemctl --user show-environment | setvar
    end
    if string match -req '/dev/tty[1-6]' (tty)
        set -gx LANG C
        set -gx XDG_SESSION_TYPE tty
    end
end

functions -e setvar
