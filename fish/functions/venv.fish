function venv --description "Enter python virtual environment"
    set -l VENV_PATH $HOME/.local/share/venv
    if test -z "$argv"
        source $VENV_PATH/cde/bin/activate.fish
    else
        source $VENV_PATH/$argv/bin/activate.fish
    end
end

set -l VENV_PATH $HOME/.local/share/venv
complete -c venv -f -a "$(string match -rg "([^/]*)\$" $VENV_PATH/*)"
