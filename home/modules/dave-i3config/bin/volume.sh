# Raise/lower/mute volume and show a dunst progress bar.

get_vol () {
    sink_status="$(wpctl get-volume @DEFAULT_SINK@)"

    if [[ $sink_status == *'MUTED'* ]]; then
        echo "MUTED"
    else
        echo "$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //')*100" | bc | cut -d. -f1
    fi
}

raise_vol () {
    wpctl set-volume @DEFAULT_SINK@ 0.1+
}

lower_vol () {
    wpctl set-volume @DEFAULT_SINK@ 0.1-
}

toggle_mute () {
    wpctl set-mute @DEFAULT_SINK@ toggle
}

show_vol () {
    volume=$(get_vol)

    if [[ $volume == *'MUTED'* ]]; then
        dunstify \
            -h string:x-canonical-private-synchronous:audio \
            "Volume: 󰝟 "
    else
        dunstify \
            -h string:x-canonical-private-synchronous:audio \
            "Volume: " \
            -h int:value:"$volume"
    fi
}

if [[ $1 == "up" ]]; then
    raise_vol
    show_vol
elif [[ $1 == "down" ]]; then
    lower_vol
    show_vol
elif [[ $1 == "mute" ]]; then
    toggle_mute
    show_vol
else
    echo "Invalid option '$1'. (up, down, mute)"
    exit 1
fi
