# shellcheck disable=SC2059

WIFI_INTERFACE="$1"
FORMAT="<span color='%s'>%s</span>%s\n"

# try to guess wifi interaface, if not provided
if [[ -z $WIFI_INTERFACE ]]; then
    WIFI_INTERFACE=$(ip link show | grep -E -o '^[0-9]+: (wlp[^:]+)' | head -n1 | sed 's/^[0-9]: //')
fi
if [[ -z $WIFI_INTERFACE ]]; then
    WIFI_INTERFACE=$(ip link show | grep -E -o '^[0-9]+: (wlan[^:]+)' | head -n1 | sed 's/^[0-9]: //')
fi

status=$(cat /sys/class/net/"$WIFI_INTERFACE"/operstate 2>&1)
valid=$(echo "$status" | grep 'No such file')
signal=""

if [[ -z "$valid" ]]; then
    signal=$( \
    iw dev "$WIFI_INTERFACE" link | \
        grep 'dBm$' | \
        grep -Eoe '-[0-9]{2}' |\
        awk '{print ($1 > -50 ? 100 :($1 < -100 ? 0 : ($1 + 100) * 2))}' \
    )
fi

color='gray'
icon=''
extra_text=" <span rise='3pt' font-size='xx-small'>$signal%</span>"

# if no device was found, don't print anything
if echo "$status" | grep -vq 'No such file'; then
    if (( signal >= 90 )); then
        color='gray'
        icon='󰤨'
        extra_text=''
    elif (( signal >= 75 )); then
        color='gray'
        icon='󰤥'
    elif (( signal >= 50 )); then
        color='gray'
        icon='󰤢'
    elif (( signal >= 25 )); then
        color='gray'
        icon='󰤟'
    else
        color='red'
        icon='󰤯'
    fi

    printf "$FORMAT" "$color" "$icon" "$extra_text"
fi
