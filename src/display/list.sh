
function jq_list() {
    echo "$1" | eval "jq -r '.[] | $2 | @csv'" | sed 's/,/, /g' | tr -d '"'
}

function jq_table() {
    filtered=$(echo "$1" | eval "jq -c '[.[] | $2]'")
    
    keys=$(echo "$filtered" | jq -cr '.[0] | keys_unsorted | @csv' | tr -d '"')
    values=$(echo "$filtered" | jq -cr '.[] | flatten | @csv' | tr -d '"')
    
    echo -e "$keys\n$values" | csvlook
}
