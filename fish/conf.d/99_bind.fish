if status is-interactive
    function dtach_detach
        if set -q DTACH_ID
            set -l pid (ps au | grep $DTACH_ID | sed '/grep/d' | awk '{print $2}')
            if test $pid
                kill -HUP $pid
            end
        end
    end

    bind ctrl-x ''
    bind ctrl-v ''

    bind ctrl-a beginning-of-line
    bind ctrl-e end-of-line

    bind ctrl-o edit_command_buffer
    bind alt-v edit_command_buffer

    bind ctrl-w backward-kill-bigword
    bind ctrl-backspace backward-kill-bigword
    bind ctrl-right forward-bigword
    bind ctrl-left backward-bigword

    bind ctrl-shift-l clear repaint

    bind alt-backspace backward-kill-word
    bind alt-left prevd-or-backward-word
    bind alt-right nextd-or-forward-word

    bind ctrl-\\ dtach_detach

    function toggle_privileged_edit
        set -l cmdline (commandline -b)
        set -l first_word (echo $cmdline | cut -d" " -f1)

        # 定义编辑器列表（包含 $EDITOR）
        set -l editors $EDITOR vim vi nano emacs neovim nvim
        # 移除空值
        set editors (string trim $editors | string match -v '')

        # 检查是否以 visudo 或 doasedit 开头
        if string match -q "visudo *" $cmdline; or string match -q "doasedit *" $cmdline
            # 已经是 visudo/doasedit，恢复成 $EDITOR
            set -l file (echo $cmdline | cut -d" " -f2-)
            set -l editor $EDITOR
            if test -z "$editor"
                set editor vim
            end
            commandline -r "$editor $file"

            # 检查是否是编辑命令
        else if contains $first_word $editors
            # 是编辑命令，转为 visudo/doasedit
            set -l file (echo $cmdline | cut -d" " -f2-)
            if command -q visudo
                commandline -r "visudo $file"
            else if command -q doasedit
                commandline -r "doasedit $file"
            else
                # fallback 到普通 sudo
                for cmd in sudo doas please run0
                    if command -q $cmd
                        fish_commandline_prepend $cmd
                        break
                    end
                end
            end

        else
            # 普通命令：sudo toggle
            for cmd in sudo doas please run0
                if command -q $cmd
                    fish_commandline_prepend $cmd
                    break
                end
            end
        end
    end

    # 绑定到 Alt-s
    bind alt-s toggle_privileged_edit
end
