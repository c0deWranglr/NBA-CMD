#!/usr/bin/env bash

_common_setup() {
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/$1" >/dev/null 2>&1 && pwd )"
    PROJECT_SRC="$PROJECT_ROOT/src"

    load "$PROJECT_ROOT/test/test_helper/bats-support/load"
    load "$PROJECT_ROOT/test/test_helper/bats-assert/load"
    
    source "$PROJECT_SRC/requirements.sh"
    source "$PROJECT_SRC/data/utils/cache.sh"
    source "$PROJECT_SRC/data/season.sh"
    source "$PROJECT_SRC/data/utils/json.sh"

    cache_dir="$PROJECT_ROOT/test/.cache"
    season_dir="${cache_dir}/${season}"
    setup_dir "${season_dir}"
}

_common_teardown() {
    if [ "${cache_dir}" ] && [[ -d "${cache_dir}" ]];
    then
        rm -rf "${cache_dir}"
    fi
}