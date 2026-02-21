function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    set -l color_normal (set_color normal)
    set -l color_vcs (set_color brpurple)
    set -l color_user
    set -l color_host
    set -l color_cwd

    if not set -q support_colors
        set support_colors (tput colors)
    end
    if test $TERM = linux
        set support_colors 16
    end
    if test $support_colors -gt 256
        set color_user '\e[38;2;138;226;52m'
        set color_host '\e[38;2;114;159;207m'
        set color_cwd '\e[38;2;207;169;0m'
        set color_time '\e[38;2;175;135;175m'
    else if test $support_colors -gt 16
        set color_user '\e[38;5;112m'
        set color_host '\e[38;5;110m'
        set color_cwd '\e[38;5;178m'
        set color_time '\e[38;5;139m'
    else if test $support_colors -gt 8
        set color_user '\e[92m'
        set color_host '\e[94m'
        set color_cwd '\e[33m'
        set color_time '\e[95m'
    else
        set color_user '\e[32m'
        set color_host '\e[34m'
        set color_cwd '\e[33m'
        set color_time '\e[35m'
    end

    # Color the prompt differently when we're root
    set -l suffix '$'
    if functions -q fish_is_root_user; and fish_is_root_user
        set suffix '#'
        if set -q fish_color_cwd_root
            set color_cwd (set_color $fish_color_cwd_root)
        end
    end

    # Color the prompt in red on error
    set -l prompt_status ''
    set -l color_status (set_color $fish_color_status)
    if test $last_status -ne 0
        set prompt_status $color_status '[' $last_status ']' $color_normal
    end

    # no space around prompt_pwd, while fish_vcs_prompt has a space before it.
    echo -e -n -s \
        $color_user $USER $color_normal @ \
        $color_host $hostname $color_normal \
        $color_time ' ' (date +%T) \
        $color_cwd ' ' (prompt_pwd) \
        (if functions -q fish_vcs_prompt
            echo -e -n -s $color_vcs (fish_vcs_prompt)
        end) $color_normal \
        ' ' $prompt_status \
        '\n' $suffix ' ' $color_normal

end
