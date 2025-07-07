# shellcheck disable=SC2059

FORMAT="<span color='%s'>󰍛<span rise='2pt' font-size='x-small'>CPU: %.2f%%</span></span>\n"

idle=$(mpstat 1 1 | grep 'Average:' | awk '{ print $12 }')
integer="${idle%%.*}"
remainder="${idle##*.}"
# this effectively gives us the value x100 for 2 digits of precision
# 1. extract the integer part
# 2. extract the first digit of the decimal part
# 3. concatenate
int_val="$integer${remainder::2}"

# convert idle speed (x100) into usage
usage=$((10000 - int_val))

# now divide by 100 and change it back to a 'float'
percent=$(printf "%.2f\n" "$( echo $usage/100 | bc -l)")

color='gray'
# values are percents (x100)
if (( usage > 8500 )); then
    color='red'
elif (( usage > 8000 )); then
    color='orange'
elif (( usage > 7000 )); then
    color='yellow'
fi

printf "$FORMAT" "$color" "$percent"
