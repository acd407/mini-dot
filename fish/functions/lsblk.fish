function lsblk --wraps lsblk --description "lsblk with custom lines"
    command lsblk -o PATH,TYPE,FSTYPE,FSUSE%,SIZE,MOUNTPOINTS $argv
end
