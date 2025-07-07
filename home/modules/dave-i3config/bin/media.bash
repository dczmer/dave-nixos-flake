# shellcheck disable=SC2059

FORMAT="<span color='%s'>%s %s</span>\n"

volume_output=$(wpctl get-volume @DEFAULT_SINK@)
status_output=$(playerctl status 2>&1)

volume=$(echo "$volume_output" | grep -E -o 'Volume: ([0-9.]+)')
muted=$(echo "$volume_output" | grep -E -o '(MUTED)')

volume_txt="?"
if [[ -n $muted ]]; then
    volume_txt="󰝟"
elif (( volume > 70 )); then
    volume_txt="󰕾"
elif (( volume > 40 )); then
    volume_txt="󰕾"
else
    volume_txt="󰕿"
fi

status_txt="?"
if [[ $status_output == 'No players found' ]]; then
    status_txt=""
elif [[ $status_output == 'Paused' ]]; then
    status_txt="󰐊"
else
    status_txt=""
fi

printf "$FORMAT" "gray" "$volume_txt" "$status_txt"
