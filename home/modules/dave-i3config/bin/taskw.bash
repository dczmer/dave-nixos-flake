# shellcheck disable=SC2059

FORMAT="<span font-size='small'> %s</span>\n"

task=$(task +ACTIVE export 2>&1)
if echo "$task" | grep -qv "command not found"; then
    task=$(echo "$task" | jq '.[0].description')
    if [[ $task == 'null' ]]; then
        task='(No task)'
    fi
else
    task="ERROR"
fi

printf "$FORMAT" "$task"
