function pp --wraps ping --description "Ping the default gateway"
    set -l gateway_ip (command ip route | grep default | awk '{print $3}' | head -n 1)
    ping -n $gateway_ip $argv
end
