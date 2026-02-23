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
end
