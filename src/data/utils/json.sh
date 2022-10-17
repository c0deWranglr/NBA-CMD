
JQ_CONCAT='def concat($keys): $keys | join(" "); '

JQ_LOCAL_DATE='def toLocalDate($fmt): split(".") | "\(.[0])Z" | fromdate | strflocaltime($fmt); '

JQ_LOOKUP_TEAM='def lookupTeam($teamId): input[] | select(.teamId == $teamId) | .nickname; '

function jq_lookup() {
    jq --argjson other "$1" "def lookup(\$id): \$other | .[] | select($2 == \$id); $3"
}
