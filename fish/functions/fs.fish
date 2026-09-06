function fs --description "Small http file server"
    set -l ips (command ip -j address | jq -r '.[].addr_info.[] | select(.family == "inet") | .local')
    set -l ip (command ip -j route | jq -r '.[] | select(.dst == "default") | .prefsrc')
    set -l url http://$ip:4780
    command -q qr && qr $url
    echo "Listen at:"
    for i in $ips
        echo -e "\t$i:4780"
    end
    python3 -c "
from http.server import test, SimpleHTTPRequestHandler as RH
RH.extensions_map = {k: v + ';charset=UTF-8' for k, v in RH.extensions_map.items()}
test(HandlerClass=RH, port=4780)
"
end
