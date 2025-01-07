function tk --description "Edit task list"
    if test -n "$argv"
        $EDITOR $HOME/.config/tk/$argv.txt
    else
        $EDITOR $HOME/.config/tk.txt
    end
end

complete -c tk -f -a "$(string match -rg "([^/]*)\.txt\$" $HOME/.config/tk/*)"
