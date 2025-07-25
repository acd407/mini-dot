# source /etc/profile with bash
if status is-login
    eval (dash -c '. /etc/profile >/dev/null 2>&1; export -p') 2>/dev/null
end

# Piping last command's output
function foot_cmd_start --on-event fish_preexec
    echo -en "\e]133;C\e\\"
end

function foot_cmd_end --on-event fish_postexec
    echo -en "\e]133;D\e\\"
end
