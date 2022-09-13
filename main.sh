#!/bin/bash

source 'src/requirements.sh'
source 'src/data/utils/downloads.sh'
source 'src/data/season.sh'
source 'src/data/teams.sh'


if [ "${1}" ];
then
    load_team_roster "${1}";

    echo $team_slug
    echo $team_id
    echo
    echo $team_roster | jq '.[] | [.fn, .ln, .pos] | @tsv' | sed 's/\\t/ /g' | tr -d '"'
else
    echo "Please specify a team roster to load"
fi
