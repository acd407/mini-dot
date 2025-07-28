function p6d --wraps ping --description "Ping alidns ipv6"
    ping -n 2400:3200::1 $argv
end
