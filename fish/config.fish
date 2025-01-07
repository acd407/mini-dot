# source /etc/profile with bash
# set this if-statement at begining of this file
# once this line being executed, it will never return.

if command -v --quiet vf
    VIRTUALFISH_ACTIVATION_FILE=$XDG_CONFIG_HOME/venv \
        VIRTUALFISH_HOME=$XDG_DATA_HOME/venv \
        VIRTUAL_ENV_DISABLE_PROMPT=1 \
        vf connect cde
end

# Piping last command's output
function foot_cmd_start --on-event fish_preexec
    echo -en "\e]133;C\e\\"
end

function foot_cmd_end --on-event fish_postexec
    echo -en "\e]133;D\e\\"
end
