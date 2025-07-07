# shellcheck disable=SC2059

FORMAT="<span color='%s'>%s</span><span rise='3pt' font-size='xx-small'>%s</span>\n"

acpi_reading=$(acpi -ba)
percent=$(echo "$acpi_reading" | grep -E -o '([0-9]{2,3})%')
if [[ -n $percent ]]; then
    percent=${percent%\%}
    online=$(echo "$acpi_reading" | grep -E -o '(on-line)')

    if [[ -n $online ]]; then
        if (( percent >= 100 )); then
            printf "$FORMAT" 'gray' '' ""
        else
            printf "$FORMAT" 'gray' '' " $percent%"
        fi
    else
        if (( percent >= 90 )); then
            printf "$FORMAT" 'gray' '' " $percent%"
        elif (( percent >= 75 )); then
            printf "$FORMAT" 'gray' '' " $percent%"
        elif (( percent >= 50 )); then
            printf "$FORMAT" 'gray' '' " $percent%"
        elif (( percent >= 25 )); then
            printf "$FORMAT" 'yellow' '' " $percent%"
        elif (( percent >= 10 )); then
            printf "$FORMAT" 'orange' '' " $percent%"
        else
            printf "$FORMAT" 'red' '' " $percent%"
        fi
    fi
fi
