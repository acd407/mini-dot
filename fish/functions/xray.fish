function format_storage_units --argument bytes
    set units KMGTPE # 单位从 K 开始
    set unit_idx 0 # 1=K, 2=M, 3=G, 4=T, 5=P, 6=E

    # 确保最小单位为 K
    while test $bytes -ge 1000.0 -a $unit_idx -lt 6 -o $unit_idx -le 0
        set bytes (math "$bytes / 1024")
        set unit_idx (math "$unit_idx + 1")
    end

    # 动态选择格式并输出
    if test $bytes -ge 100.0
        printf " %3.0f%s\n" (math "round($bytes)") (string sub --start $unit_idx --length 1 $units)
    else if test $bytes -ge 10.0
        printf "%4.1f%s\n" $bytes (string sub --start $unit_idx --length 1 $units)
    else
        printf "%4.2f%s\n" $bytes (string sub --start $unit_idx --length 1 $units)
    end
end

function xray --description "Add Xray subcommands"
    if test "$argv[1]" = stat
        set -l up (xray api stats -name "outbound>>>proxy>>>traffic>>>uplink" | jq '.stat.value')
        if test $up != null
            echo -en "Upload:   "
            format_storage_units $up
        end
        set -l down (xray api stats -name "outbound>>>proxy>>>traffic>>>downlink" | jq '.stat.value')
        if test $down != null
            echo -en "Download: "
            format_storage_units $down
        end
    else
        command xray $argv
    end
end

complete -c xray -f -a "run version api convert tls uuid x25519 wg stat"
