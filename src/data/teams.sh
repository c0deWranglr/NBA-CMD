

##########################################
#  Functions for downloading team data   #
##########################################


# Downloads a list of all NBA teams. Stores results in $teams_list.
# Sample schema:
# [
#   ...
#   {
#     "isNBAFranchise": true,
#     "isAllStar": false,
#     "city": "Washington",
#     "altCityName": "Washington",
#     "fullName": "Washington Wizards",
#     "tricode": "WAS",
#     "teamId": "1610612764",
#     "nickname": "Wizards",
#     "urlName": "wizards",
#     "teamShortName": "Washington",
#     "confName": "East",
#     "divName": "Southeast"
#   }
# ]
function download_teams() {
    teams_list=$(
        cache "$teams_list" \
              "$season_dir/teams.json" \
              'download "http://data.nba.net/prod/v1/$season/teams.json" \
                      | jq "[.league | .standard | .[] | select(.isNBAFranchise == true)]"' \
              2592000 # Cache for 30 days
    )
}

# Extracts one team from $teams_list. Stores team json in $team_metadata
# Extracts team id for api calls. Stores team id in $team_id
# Extracts team slug (short name). Stores slug in $team_slug
# Creates a $team_dir from $season_dir/$team_slug
function metadata_for_team() {
    download_teams;
    team_metadata=$(echo "$teams_list" | jq -c --arg selected_team "${1}" '.[] | select(.fullName | test($selected_team; "i"))')
    team_id=$(echo "$team_metadata" | jq '.teamId' | tr -d '"')
    team_slug=$(echo "$team_metadata" | jq '.urlName' | tr -d '"')

    team_dir="$season_dir/$team_slug"
    setup_dir "$team_dir"
}

# Downloads a list of players in a team's roster. Stores results in $team_roster.
# Sample schema:
# [
#   {
#     "fn": "LeBron",
#     "ln": "James",
#     "pid": 2544,
#     "num": "6",
#     "pos": "F",
#     "dob": "1984-12-30",
#     "ht": "6-9",
#     "wt": 250,
#     "y": 19,
#     "twc": "0",
#     "hcc": "St. Vincent-St. Mary HS (OH)/USA",
#     "name": "LeBron James"
#   },
#   ...
# ]
function load_team_roster() {
    metadata_for_team $@;

    team_roster=$(
        cache "$team_roster" \
              "$team_dir/roster.json" \
              'download "http://data.nba.net/v2015/json/mobile_teams/nba/${season}/teams/${team_slug}_roster.json" \
                      | jq "${JQ_CONCAT} .t | .pl | map(.+{\"name\": concat([.fn, .ln])})"'
    )
}
