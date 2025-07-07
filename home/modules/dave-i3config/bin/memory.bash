# shellcheck disable=SC2059

FORMAT="<span color='%s'>󰍛<span font-size='x-small' rise='2pt'>Free: %.1f%%</span></span>\n"

output=$(free --mega | grep 'Mem:')
total=$(echo "$output" | awk '{ print $2 }')
free=$(echo "$output" | awk '{ print $4 }')

if (( free/total >= 1 )); then
    echo "FULL"
fi

percent=$(echo "$free/$total" | bc -l)
percent="${percent:1:2}"."${percent:3:1}"

color='gray'
if (( "${percent%%.*}" < 25 )); then
    color='red'
fi

printf "$FORMAT" "$color" "$percent"
