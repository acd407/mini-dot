function erc --description "Edit fish config file"
    if test -n "$argv"
        $EDITOR $HOME/.config/fish/conf.d/$argv.fish
    else
        $EDITOR $HOME/.config/fish/config.fish
    end
end

complete -c erc -n __fish_use_subcommand -xa "$(string match -rg "([^/]*)\.fish\$" $HOME/.config/fish/conf.d/*)"
