
function load_schedule() {
    season_schedule=$(
        cache "$season_schedule" \
              "$season_dir/schedule.json" \
              'download "http://data.nba.net/prod/v2/${season}/schedule.json" \
                      | jq "$JQ_LOCAL_DATE .league | .standard | map({ \
                        \"gameId\": .gameId, \
                        \"seasonStageId\": .seasonStageId, \
                        \"gameUrlCode\": .gameUrlCode, \
                        \"gameStartUtc\": .startTimeUTC, \
                        \"gameStartLocalDate\": .startTimeUTC | toLocalDate(\"%b %-d\"), \
                        \"gameStartLocalTime\": .startTimeUTC | toLocalDate(\"%-I:%M %p\"), \
                        \"calendarMonth\": .startTimeUTC | toLocalDate(\"%B\"), \
                        \"homeTeamId\": .hTeam.teamId, \
                        \"homeScore\": .hTeam.score, \
                        \"awayTeamId\": .vTeam.teamId, \
                        \"awayScore\": .vTeam.score \
                      })"'
    )
}