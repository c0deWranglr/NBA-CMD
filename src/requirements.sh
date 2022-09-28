
function setup_dir() {
    mkdir -p "${1}" &> /dev/null
}

data_dir="$HOME/.nba-cmd/cache"
setup_dir "${data_dir}"

function require { 
    if ! command -v $1 &> /dev/null
    then 
        echo "$1 is required, please install it."
        exit 1
    fi 
}

require wget
require jq
require csvlook
