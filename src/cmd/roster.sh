
function help_roster() {
    command_help "roster" "Displays the roster for a team" \
    "-t | --team" "Selects which team to load the roster for"
}

function opt_roster() {
    case "$1" in
        -t|--team)
            OPT_TEAM="$2"
            ;;
    esac
}

function cmd_roster() {
    require_option "$OPT_TEAM"
    echo "Loading team '$OPT_TEAM' roster"
    load_team_roster "$OPT_TEAM";
    if [ "$team_roster" ]; then
        echo
        jq_table "$team_roster" '{"Name": .name, "Position": .pos}'
    else
        echo "Unable to load roster. Please try again later"
        exit 1
    fi
}

register_command 'roster' 'Display the roster for a team'
