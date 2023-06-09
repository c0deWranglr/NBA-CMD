
function help_scores() {
    command_help "scores" "Display game scores for a date" \
                 "-t | --team" "(Optional) Only display scores for a specific team." \
                 "-d | --date" "Relative or Absolute date to show scores for. Ex \"-1 day\" or \"2022-10-18\". Defaults to today."
}

function opt_scores() {
    case "$1" in
        -t|--team)
            OPT_TEAM="$2"
        ;;
        -d|--date)
            OPT_DATE="$2"
        ;;
    esac
}

function cmd_scores() {
    download_teams

    if [ "$OPT_DATE" ]; then
        date=$(date --date "$OPT_DATE" "+%Y-%m-%d")
    else
        date=$(date "+%Y-%m-%d")
    fi
    echo "Loading scores for: $date"
    
    if [ "$OPT_TEAM" ]; then
        metadata_for_team "$OPT_TEAM"
    fi

    load_scoreboard "$date";
    echo "$scoreboard" > tmpScores;
    exit;

    # scores=$(load_scores "$date" \
    #        | jq_lookup "$teams_list" '.teamId' 'map(.+{"homeTeam": lookup(.homeTeamId).nickname, "awayTeam": lookup(.awayTeamId).nickname})' \
    #        | jq --arg team "$team_id" 'if ($team | length > 0) then [ .[] | select(.homeTeamId == $team or .awayTeamId == $team) ] else . end' \
    #     )
    
    if [ "$scoreboard" == "" ]; then 
        echo "Failed to load scores. Please try again later."
    elif [ "$scoreboard" != "[]" ]; then
        jq_table "$scoreboard | .GameHeader | .[]" '{"Match Up": .GAMECODE, "Status": .GAME_STATUS_TEXT}'
    else
        echo "There are no games for the date provided!"
    fi
}

register_command "scores" "Display game scores for a date"
