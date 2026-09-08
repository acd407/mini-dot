 # 加载 systemd environment.d 风格的环境变量文件
function load_environment_d --description "Load environment variables from environment.d files"
    set -l files
    if set -q argv[1]
        set files $argv
    else
        set files ~/.config/environment.d/*
    end

    for file in $files
        if test -f $file
            while read -l line
                set line (string trim $line)
                test -z "$line" && continue

                # 跳过纯注释行
                if string match -q '^#' $line
                    continue
                end

                # 去除行内注释（简单处理，不会处理引号内的 #）
                set line (string replace -r '#.*$' '' $line)
                set line (string trim $line)
                test -z "$line" && continue

                # 分割 KEY=VALUE（只分割第一个等号）
                set -l kv (string split -m1 = $line)
                if test (count $kv) -ne 2
                    # 错误信息输出到 stderr，不会影响标准输出
                    echo "警告: 无效行 '$line' 在文件 $file 中" >&2
                    continue
                end

                set -l key (string trim $kv[1])
                set -l value (string trim $kv[2])

                # 尝试去除外层双引号（若存在）
                set value (string replace -r '^"([^"]*)"$' '$1' -- $value)
                # 尝试去除外层单引号（若存在）
                set value (string replace -r "^'([^']*)'\$" '$1' -- $value)

                # 将 ${VAR} 转换为 {$VAR}，以兼容 Fish 语法
                set value (string replace -r '\$\{([^}]+)\}' '{\$$1}' -- $value)

                # 使用 eval 设置，同时展开 $VAR 和 {$VAR}
                eval "set -gx $key \"$value\""
            end < $file
        end
    end
end
