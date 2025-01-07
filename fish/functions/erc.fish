function erc --description "Edit fish config file"
    if test -n "$argv"
        $EDITOR $HOME/.config/fish/conf.d/$argv.fish
    else
        $EDITOR $HOME/.config/fish/config.fish
    end
end

complete -c erc -f -a "$(string match -rg "([^/]*)\.fish\$" $HOME/.config/fish/conf.d/*)"
