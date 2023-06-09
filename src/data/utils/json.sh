
JQ_CONCAT='def concat($keys): $keys | join(" "); '

JQ_LOCAL_DATE='def toLocalDate($fmt): split(".") | "\(.[0])Z" | fromdate | strflocaltime($fmt); '

JQ_LOOKUP_TEAM='def lookupTeam($teamId): input[] | select(.teamId == $teamId) | .nickname; '

function jq_lookup() {
    jq --argjson other "$1" "def lookup(\$id): \$other | .[] | select($2 == \$id); $3"
}

function jq_map_result_sets() {
    jq ". | map({ \
              \"\(.name)\": ( \
                  .headers as \$headers | \
                  .rowSet | \
                  map(. as \$row | \
                      [foreach range(\$headers|length) as \$idx ({}; .+{\"\(\$headers[\$idx])\": \"\(\$row[\$idx])\"};.)] | last \
                  ) \
                ) \
            }) \
          | add"
}

function jq_group_by() {
    jq ". as \$input | [(.. | objects |.$1//empty)] | unique | map([(. as \$group | \$input | .. | objects | select(.$1 == \$group))])" # to_entries[] as \$entries | [ foreach \$entries as \$entry ({}; .+foreach \$entry.value as \$value ({}; .+{\"\(\$entry.key)\":\$value}; .); .) ]"
}