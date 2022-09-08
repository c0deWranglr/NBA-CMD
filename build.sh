#!/bin/bash

file="${2}"

function copy_file() {
    echo "Loading file $1"
    while IFS= read -r line
    do
        read -ra line_parts <<< "${line}"
        if [ "${line_parts[0]}" == "source" ] # Copy the contents of each source file into the output
        then
            copy_file $(eval echo ${line_parts[1]})
        else
            printf '%s\n' "$line" >> $file
        fi
    done < "$1"
}

rm $file &> /dev/null

copy_file "${1}"

chmod 744 $file &> /dev/null
