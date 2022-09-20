
setup() {
    load '../test_helper/common-setup'
    _common_setup

    source "$PROJECT_SRC/data/teams.sh"
}

teardown() {
    _common_teardown
}

function download() {
    echo "${download_return}"
}

@test "Only Load NBA Teams From Team List" {
    # Return json with two teams. 1 International and 1 NBA.
    download_return='{"_internal":{"pubDateTime":"2022-01-01 00:00:00.000 EDT","igorPath":"","xslt":"NBA/xsl/league/roster/marty_teams_list.xsl","xsltForceRecompile":"true","xsltInCache":"false","xsltCompileTimeMillis":"33","xsltTransformTimeMillis":"16","consolidatedDomKey":"prod__transform__marty_teams_list__000000000000","endToEndTimeMillis":"1881"},"league":{"standard":[{"isNBAFranchise":false,"isAllStar":false,"city":"International","altCityName":"International","fullName":"International Test","tricode":"INT","teamId":"111","nickname":"intest","urlName":"intest","teamShortName":"International","confName":"Intl","divName":""},{"isNBAFranchise":true,"isAllStar":false,"city":"NBA","altCityName":"NBA","fullName":"NBA Test","tricode":"NBA","teamId":"222","nickname":"NBATest","urlName":"nbatest","teamShortName":"NBA","confName":"East","divName":"Southeast"}]}}'
    
    load_teams_list

    num_teams=$(echo $teams_list | jq 'length')
    echo "Num teams: $num_teams"
    [ "${num_teams}" -eq 1 ]

    team=$(echo $teams_list | jq -cr '.[0]')
    [ "${team}" = '{"isNBAFranchise":true,"isAllStar":false,"city":"NBA","altCityName":"NBA","fullName":"NBA Test","tricode":"NBA","teamId":"222","nickname":"NBATest","urlName":"nbatest","teamShortName":"NBA","confName":"East","divName":"Southeast"}' ]
}

@test "Load Team Metadata From NBA Team List" {
    # Return json with two teams. 1 International and 1 NBA.
    download_return='{"_internal":{"pubDateTime":"2022-01-01 00:00:00.000 EDT","igorPath":"","xslt":"NBA/xsl/league/roster/marty_teams_list.xsl","xsltForceRecompile":"true","xsltInCache":"false","xsltCompileTimeMillis":"33","xsltTransformTimeMillis":"16","consolidatedDomKey":"prod__transform__marty_teams_list__000000000000","endToEndTimeMillis":"1881"},"league":{"standard":[{"isNBAFranchise":false,"isAllStar":false,"city":"International","altCityName":"International","fullName":"International Test","tricode":"INT","teamId":"111","nickname":"intest","urlName":"intest","teamShortName":"International","confName":"Intl","divName":""},{"isNBAFranchise":true,"isAllStar":false,"city":"NBA","altCityName":"NBA","fullName":"NBA Test","tricode":"NBA","teamId":"222","nickname":"NBATest","urlName":"nbatest","teamShortName":"NBA","confName":"East","divName":"Southeast"}]}}'

    load_team_metadata "test"

    echo "METADATA: ${team_metadata}"
    [ "${team_metadata}" = '{"isNBAFranchise":true,"isAllStar":false,"city":"NBA","altCityName":"NBA","fullName":"NBA Test","tricode":"NBA","teamId":"222","nickname":"NBATest","urlName":"nbatest","teamShortName":"NBA","confName":"East","divName":"Southeast"}' ]

    echo "ID: ${team_id}"
    [ "${team_id}" = "222" ]
    
    echo "SLUG: ${team_slug}"
    [ "${team_slug}" = "nbatest" ]
    
    echo "DIR: ${team_dir}"
    [ "${team_dir}" = "${season_dir}/nbatest" ]
}

@test "Can Load Players from Roster api" {
    # Fake a team list file to prevent downloading one
    touch "${season_dir}/teams.json"

    # Return json with two fake players.
    download_return='{"t":{"tid":123,"pl":[{"fn":"Test","ln":"Person","pid":111,"num":"1","pos":"F-G","dob":"1980-01-01","ht":"6-8","wt":250,"y":16,"twc":"0","hcc":"USA"},{"fn":"Test2","ln":"Person2","pid":222,"num":"2","pos":"G","dob":"2000-01-01","ht":"6-3","wt":220,"y":1,"twc":"0","hcc":"USA"}],"ta":"TES","tn":"Test","tc":"Bash"}}'

    load_team_roster "doesn't matter"
    
    num_records=$(echo $team_roster | jq 'length')
    [ "${num_records}" -eq 2 ]

    player1=$(echo $team_roster | jq -cr '.[0]')
    [ "${player1}" = '{"fn":"Test","ln":"Person","pid":111,"num":"1","pos":"F-G","dob":"1980-01-01","ht":"6-8","wt":250,"y":16,"twc":"0","hcc":"USA","name":"Test Person"}' ]

    player2=$(echo $team_roster | jq -cr '.[1]')
    [ "${player2}" = '{"fn":"Test2","ln":"Person2","pid":222,"num":"2","pos":"G","dob":"2000-01-01","ht":"6-3","wt":220,"y":1,"twc":"0","hcc":"USA","name":"Test2 Person2"}' ]
}