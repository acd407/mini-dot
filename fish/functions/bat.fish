function bat --wraps bat --description "A cat(1) clone with syntax highlighting and Git integration."
    if command -v --quiet bat
        command bat -P --style plain --theme OneHalfDark $argv
    else if command -v --quiet batcat
        batcat -P --style plain --theme OneHalfDark $argv
    end
end
