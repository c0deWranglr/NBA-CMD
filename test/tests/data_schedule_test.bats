
setup() {
    load '../test_helper/common-setup'
    _common_setup "../../"

    source "$PROJECT_SRC/data/schedule.sh"
}

teardown() {
    _common_teardown
}

function download() {
    echo "${download_return}"
}

@test "Can Load Schedule from api" {
    # Fix timezone for test
    export TZ=America/Denver

    # Don't use caches
    INVALIDATE_CACHES=1

    # Return json with two fake games.
    download_return='{"league":{"standard":[{"gameId":"123","seasonStageId":1,"gameUrlCode":"19710101/TEST","statusNum":3,"extendedStatusNum":0,"isStartTimeTBD":false,"startTimeUTC":"2022-09-30T10:00:00.000Z","startDateEastern":"20220930","isNeutralVenue":false,"startTimeEastern":"6:00 AM ET","isBuzzerBeater":false,"period":{"current":0,"type":0,"maxRegular":4},"nugget":{"text":""},"hTeam":{"teamId":"1234","score":"100","win":"1","loss":"0"},"vTeam":{"teamId":"4321","score":"99","win":"0","loss":"1"},"watch":{"broadcast":{"video":{"regionalBlackoutCodes":"","isLeaguePass":true,"isNationalBlackout":false,"isTNTOT":false,"canPurchase":false,"isVR":false,"isNextVR":false,"isNBAOnTNTVR":false,"isMagicLeap":false,"isOculusVenues":false,"national":{"broadcasters":[{"shortName":"NBA TV","longName":"NBA TV"}]},"canadian":[],"spanish_national":[]}}}},{"gameId":"12345","seasonStageId":2,"gameUrlCode":"19710101/TEST","statusNum":3,"extendedStatusNum":0,"isStartTimeTBD":false,"startTimeUTC":"2022-10-01T02:00:00.000Z","startDateEastern":"20220930","isNeutralVenue":false,"startTimeEastern":"10:00 PM ET","isBuzzerBeater":false,"period":{"current":4,"type":0,"maxRegular":4},"nugget":{"text":""},"hTeam":{"teamId":"123","score":"99","win":"0","loss":"1"},"vTeam":{"teamId":"321","score":"100","win":"1","loss":"0"},"watch":{"broadcast":{"video":{"regionalBlackoutCodes":"","isLeaguePass":true,"isNationalBlackout":false,"isTNTOT":false,"canPurchase":false,"isVR":false,"isNextVR":false,"isNBAOnTNTVR":false,"isMagicLeap":false,"isOculusVenues":false,"national":{"broadcasters":[{"shortName":"NBA TV","longName":"NBA TV"}]},"canadian":[{"shortName":"NBAC","longName":"NBA TV Canada"}],"spanish_national":[]}}}}]}}'

    load_schedule
    
    num_records=$(echo $season_schedule | jq 'length')
    [ "${num_records}" -eq 2 ]

    game1=$(echo $season_schedule | jq -cr '.[0]')
    [ "${game1}" = '{"gameId":"123","seasonStageId":1,"gameUrlCode":"19710101/TEST","gameStartUtc":"2022-09-30T10:00:00.000Z","gameStartLocalDate":"Sep 30","gameStartLocalTime":"4:00 AM","calendarMonth":"September","homeTeamId":"1234","homeScore":"100","awayTeamId":"4321","awayScore":"99"}' ]

    game2=$(echo $season_schedule | jq -cr '.[1]')
    [ "${game2}" = '{"gameId":"12345","seasonStageId":2,"gameUrlCode":"19710101/TEST","gameStartUtc":"2022-10-01T02:00:00.000Z","gameStartLocalDate":"Sep 30","gameStartLocalTime":"8:00 PM","calendarMonth":"September","homeTeamId":"123","homeScore":"99","awayTeamId":"321","awayScore":"100"}' ]
}