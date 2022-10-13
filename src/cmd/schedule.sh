
function help_schedule() {
    command_help "schedule" "Display league game schedule" \
                 "-t | --team" "(Optional) Which team to pull the schedule for by nickname"
}

function opt_schedule() {
    case "$1" in
        -t|--team)
            OPT_TEAM="$2"
        ;;
    esac
}

function cmd_schedule() {
    download_teams
    load_schedule

    if [ "$OPT_TEAM" ]; then
        metadata_for_team "$OPT_TEAM"
    fi

    schedule_with_teams=$(echo "$season_schedule" \
                        | jq_lookup "$teams_list" '.teamId' 'map(.+{"homeTeam": lookup(.homeTeamId).nickname, "awayTeam": lookup(.awayTeamId).nickname})' \
                        | jq --arg team "$team_id" 'if ($team | length > 0) then [ .[] | select(.homeTeamId == $team or .awayTeamId == $team) ] else . end' \
                        | jq -cr 'group_by(.calendarMonth) | sort_by(.[0] | .gameStartUtc) | map(. | tojson) | join("|")')
    IFS='|' read -a schedule_by_month <<< "$schedule_with_teams"

    output=$(
        for month_schedule in "${schedule_by_month[@]}"; do
            jq_table "$month_schedule" '{"Game Start": "\(.gameStartLocalDate) @ \(.gameStartLocalTime)", "Teams": "\(.awayTeam) @ \(.homeTeam)"}'
            echo; echo;
        done
    )

    viewer="less --use-color"

    today="$(date '+%b %-d')"
    if [[ "$output" =~ "$today" ]]; then
        viewer="$viewer -j.5 -I +/\"^.*($today).*$\""
    fi

    echo "$output" | eval "$viewer"
}

register_command "schedule" "Display league game schedule"
