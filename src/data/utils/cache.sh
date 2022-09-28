
DEFAULT_CACHE_SECONDS=86400

function cache() {
    if [ "$1" ]; then echo "$1"; return; fi


    if [ "${INVALIDATE_CACHES}" ] || [ ! -f "$2" ] || [ $(($(date +'%s') - $(stat -c '%Y' "$2"))) -gt ${4:-$DEFAULT_CACHE_SECONDS} ]
    then
        eval "$3" >| "$2"
    fi
    
    cat "$2"
}