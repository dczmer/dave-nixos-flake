# shellcheck disable=SC2059

FORMAT="<span font-size='x-small' color='gray'>󱕱 %s</span>\n"

output=$(uptime | grep -E -o 'load average: [0-9.]+' | awk '{ print $3 }')
printf "$FORMAT" "$output"
