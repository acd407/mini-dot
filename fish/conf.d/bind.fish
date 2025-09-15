function bind_elevation
    set -l cmdline (commandline -b)

    if test -n "$cmdline"
        # 将命令行分割成单词
        set -l tokens (string split " " -- $cmdline)

        # 检查第一个单词是否是vi/vim/nvim
        if contains $tokens[1] vi vim nvim $EDITOR
            # 替换第一个单词为doasedit
            set tokens[1] doasedit
            # 重新构建命令行
            commandline -r (string join " " -- $tokens)
        else
            for cmd in sudo doas please
                if command -q $cmd
                    fish_commandline_prepend $cmd
                    break
                end
            end
        end
    end
end

if status is-interactive
    bind ctrl-o edit_command_buffer
    bind ctrl-w backward-kill-bigword
    bind ctrl-right forward-bigword
    bind ctrl-left backward-bigword
    bind ctrl-shift-l "clear" repaint
    bind alt-s bind_elevation
end
