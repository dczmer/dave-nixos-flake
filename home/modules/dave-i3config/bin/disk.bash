# shellcheck disable=SC2059

FORMAT="<span font-size='small' color='%s'><span rise='2pt' font-size='x-small'> Used: %s%%</span></span>\n"

used=$(df -h / | tail -n1 | awk '{ print $5 }')
used=${used%\%}

color="gray"
if (( used > 90 )); then
    color="red"
elif (( percent > 70 )); then
    color="yellow"
fi

printf "$FORMAT" "$color" "$used"
