#!/bin/bash

source 'src/requirements.sh'
source 'src/data/utils/downloads.sh'
source 'src/data/utils/json.sh'
source 'src/data/season.sh'
source 'src/data/teams.sh'

source 'src/display/list.sh'

load_teams_list
echo "Supported teams:"
jq_table "$teams_list" '{"Team Name": .fullName, "Conference": .confName, "Division": .divName}'
echo

if [ "${1}" ];
then
    echo "Loading team $1's roster"
    load_team_roster "${1}";
    echo
    jq_table "$team_roster" '{"Name": .name, "Position": .pos}'
else
    echo "Please specify a team roster to load"
fi
