function tk --description "Edit task list"
    if test -n "$argv"
        $EDITOR $HOME/.config/tk/$argv
    else
        $EDITOR $HOME/.config/tk.txt
    end
end

complete -c tk -n __fish_use_subcommand -xa "$(find $HOME/.config/tk/ -type f | sed "s|$XDG_CONFIG_HOME/tk/||")"
