function aw --description "add system file to git"
    doas ln -v $argv[1] $HOME/.config/.links/systemcfg/(echo $argv[1] | sed 's/\//\\\/g')
end
