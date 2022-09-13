
if [ -z $season ]; then
    season=$(date +%Y)
    if [ $(date +%m) -le 6 ]; then
        season=$((season-1))
    fi;
fi;

season_dir="${data_dir}/${season}"
setup_dir "${season_dir}"
