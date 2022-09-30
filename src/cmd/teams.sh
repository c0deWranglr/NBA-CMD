
function help_teams() {
    command_help "teams" "Displays a list of all NBA teams"
}

function opt_teams() {
    # No options
    return 0
}

function cmd_teams() {
    download_teams
    if [ "$teams_list" ]; then
        echo "Here is a list of supported teams:"
        jq_table "$teams_list" '{"Team Name": .fullName, "Conference": .confName, "Division": .divName}'
    else
        echo "Unable to load teams. Please try again later"
        exit 1
    fi
}

register_command 'teams' 'Display a list of nba teams'
