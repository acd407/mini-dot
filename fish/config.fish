# 该文件最后被执行
# source /etc/profile with dash
if status is-login
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
        systemctl --user import-environment $etc_envs_keys
    else
        echo "No new environment variables to import" >&2
    end

    rm -f $oldenv $newenv
end

# Piping last command's output
function foot_cmd_start --on-event fish_preexec
    echo -en "\e]133;C\e\\"
end

function foot_cmd_end --on-event fish_postexec
    echo -en "\e]133;D\e\\"
end
