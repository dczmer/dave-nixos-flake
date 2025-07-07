# shellcheck disable=SC2059

FORMAT="<span font-size='x-small' color='%s'>%s %s°C</span>\n"

reading=$(paste \
    <(cat /sys/class/thermal/thermal_zone*/type) \
    <(cat /sys/class/thermal/thermal_zone*/temp) \
    | column -s $'\t' -t \
    | grep x86_pkg_temp \
    | awk '{ print $2 }' \
)
temp=$((reading / 1000))

icon=""
color="gray"
if (( temp >= 80 )); then
    icon="󰸁"
    color="red"
elif (( temp >= 75 )); then
    icon=""
    color="orange"
elif (( temp >= 70 )); then
    icon=""
    color="yellow"
fi

printf "$FORMAT" "$color" "$icon" "$temp"
