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

        # 特权编辑器：doasedit 是通用特权编辑器（同 sudoedit）；visudo 只用于编辑 sudoers，不作为通用编辑器
        set -l priv_editors sudoedit doasedit

        # 特权提升工具列表（兜底用）
        set -l priv_bins sudo doas please run0

        # 定义编辑器列表（包含 $EDITOR）
        set -l editors $EDITOR vim vi nano emacs neovim nvim
        # 移除空值
        set editors (string trim $editors | string match -v '')

        # 已经是特权编辑命令（eg. sudoedit/doasedit file），去掉前缀恢复成普通 $EDITOR
        if contains $first_word $priv_editors
            set -l file (echo $cmdline | cut -d" " -f2-)
            set -l editor $EDITOR
            if test -z "$editor"
                set editor vim
            end
            commandline -r "$editor $file"

            # 是普通编辑命令，加上特权编辑器前缀
        else if contains $first_word $editors
            set -l file (echo $cmdline | cut -d" " -f2-)
            if command -q sudoedit
                commandline -r "sudoedit $file"
            else if command -q doasedit
                commandline -r "doasedit $file"
            else
                for cmd in $priv_bins
                    if command -q $cmd
                        fish_commandline_prepend $cmd
                        break
                    end
                end
            end

        else
            # 普通命令：sudo toggle
            for cmd in $priv_bins
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
