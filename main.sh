#!/bin/bash

data_dir=".cache"

source 'lib/requirements.sh'
source 'lib/data/teams.sh'


if [ "${1}" ];
then
    load_team_roster "${1}";

    echo $team_slug
    echo $team_id
    echo
    echo $team_roser | jq '.[] | [.fn, .ln, .pos] | @tsv' | sed 's/\\t/ /g' | tr -d '"'
else
    echo "Please specify a team roster to load"
fi
