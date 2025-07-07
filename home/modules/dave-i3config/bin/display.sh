# Raise/lower display brightness and show a dunst progress bar.

get_bright () {
    brightnessctl --class='backlight' | grep -Eo "([0-9]+%)" | sed 's/%//'
}

bright_up () {
    brightnessctl --class='backlight' s 10%+
}

bright_down () {
    brightnessctl --class='backlight' s 10%-
}

show_bright () {
    dunstify \
        -h string:x-canonical-private-synchronous:brightness \
        "Brightness: " \
        -h int:value:"$(get_bright)"
}

if [[ $1 == "up" ]]; then
    bright_up
    show_bright
elif [[ $1 == "down" ]]; then
    bright_down
    show_bright
else
    echo "Invalid option '$1'. (up, down)"
    exit 1
fi
