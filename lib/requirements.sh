
mkdir "${data_dir}" &> /dev/null

function require { 
    if ! command -v $1 &> /dev/null
    then 
        echo "$1 is required, please install it."
        exit 1
    fi 
}

require wget
require jq
