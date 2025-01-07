function fs --description "Small http file server"
    set -l url http://(command ip route | grep default | awk '{print $(NF-2)}' | head -n 1):4780
    qr $url
    python3 -m http.server 4780 $argv
end
