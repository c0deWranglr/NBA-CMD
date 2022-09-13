
function load_teams_list() {
    if [ $teams_list ]; then return; fi

    if [ ! -f "${season_dir}/teams.json" ]
    then
        download "http://data.nba.net/prod/v1/${season}/teams.json" |\
         jq '[.league | .standard | .[] | select(.isNBAFranchise == true)]' >| "${season_dir}/teams.json"
    fi
    
    teams_list=$(cat "${season_dir}/teams.json")
}

function load_team_metadata() {
    load_teams_list;
    team_metadata="$(echo $teams_list | jq -c --arg selected_team "${1}" '.[] | select(.fullName | test($selected_team; "i"))')"
    team_id="$(echo $team_metadata | jq '.teamId' | tr -d '"')"
    team_slug="$(echo $team_metadata | jq '.urlName' | tr -d '"')"

    team_dir="${season_dir}/${team_slug}"
    setup_dir "${team_dir}"
}

function load_team_roster() {
    load_team_metadata $@;
    
    download "http://data.nba.net/v2015/json/mobile_teams/nba/${season}/teams/${team_slug}_roster.json" |\
     jq '.t | .pl' >| "${team_dir}/roster.json"

    team_roster=$(cat "${team_dir}/roster.json")
}
