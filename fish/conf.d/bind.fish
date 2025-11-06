function dtach_escape
    set pid $fish_pid
    set final false

    while test $pid -gt 1
        if test -r "/proc/$pid/comm" -a -r "/proc/$pid/stat"
            read -l comm < "/proc/$pid/comm"
            if test "$comm" = dtach
                if test $final = true
                    kill -HUP $pid
                    return 0
                end
                set final true
            end
            read -l stat_content < "/proc/$pid/stat"
            set pid (string split " " -- $stat_content)[4]
        else
            break
        end
    end
    return 1
end

if status is-interactive
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

    bind ctrl-\\ dtach_escape
end
