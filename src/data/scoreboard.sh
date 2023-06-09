
function load_scoreboard() {
  setup_dir "$season_dir/scoreboard/"
  scoreboard=$(\
    cache "$scoreboard" "$season_dir/scoreboard/$1.json" \
      'download "http://stats.nba.com/stats/scoreboardv2/?leagueId=00&gameDate='+$1+'&dayOffset=0" --header="Referer: http://stats.nba.com/stats/" | \
        jq ".resultSets" | \
        jq_map_result_sets | \
        jq_group_by GAME_ID' \
      5 \
  ) # Cached for 5 seconds
        # map(. + { \
        #     \"gameStartLocalDate\": .startTimeUTC | toLocalDate(\"%b %-d\"), \
        #     \"gameStartLocalTime\": .startTimeUTC | toLocalDate(\"%-I:%M %p\"), \
        #     \"homeTeamId\": .hTeam.teamId, \
        #     \"homeWL\": \"\(.hTeam.win)-\(.hTeam.loss)\", \
        #     \"homeScore\": .hTeam.score, \
        #     \"awayTeamId\": .vTeam.teamId, \
        #     \"awayScore\": .vTeam.score, \
        #     \"awayWL\": \"\(.vTeam.win)-\(.vTeam.loss)\" \
        #   })"
} 