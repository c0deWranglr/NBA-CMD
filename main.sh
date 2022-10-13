#!/bin/bash

source 'src/requirements.sh'

source 'src/data/utils/downloads.sh'
source 'src/data/utils/cache.sh'
source 'src/data/utils/json.sh'
source 'src/data/season.sh'
source 'src/data/teams.sh'
source 'src/data/schedule.sh'

source 'src/display/list.sh'

function help() {
    echo "NBA-CMD: A command line utility for nba information"
    echo "Usage: nbac {command} [options]"
    echo -e "Commands:$REGISTERED_COMMANDS"
    echo "Try nbac {command} --help for help with a command"
    exit
}

function command_help() {
    echo "nbac $1 [options]"
    echo "Description: $2"
    echo 
    echo "Required Options:"
    echo -e "\t-h | --help -> Display this message"
    shift; shift;
    while [[ $# -gt 0 ]]; do
        echo -e "\t$1 -> $2"; shift; shift
    done
    exit
}

function is_command() {
    if [[ $(type -t "opt_$1") == function ]] \
       && [[ $(type -t "cmd_$1") == function ]] \
       && [[ $(type -t "help_$1") == function ]]
    then
        echo "true"
    fi
}

function register_command() {
    if [ $(is_command "$1") ]; then
        REGISTERED_COMMANDS="$REGISTERED_COMMANDS\n\t$1: $2"
    fi
}

function require_option() {
    if [ ! "$1" ]; then
        echo "Please specify the required option!"; echo; eval "help_$command"; exit 1
    fi
}

# Load commands
source 'src/cmd/teams.sh'
source 'src/cmd/roster.sh'
source 'src/cmd/schedule.sh'

# Run the command
command="$1"
if [[ "$command" == "-h" || "$command" == "--help" ]]; then
    help
elif [ $(is_command "$command") ]; then
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                eval "help_$command"; exit;
                ;;
            -*|--*)
                eval "opt_$command $1 $2"
                shift
                shift
                ;;
            *)
                echo "Invalid option $1!"
                eval "help_$command"; exit;
                ;;
        esac
    done
    eval "cmd_$command"
else 
    echo "Unknown command: $command!"
    echo
    help
fi
