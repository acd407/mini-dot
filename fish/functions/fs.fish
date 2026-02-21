function fs --description "Small http file server"
    set -l ip (command ip route | grep default | awk '{print $(NF-2)}' | head -n 1)
    set -l url http://$ip:4780
    qr $url
    python3 -m http.server --bind $ip 4780 $argv
end
