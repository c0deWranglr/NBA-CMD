#!/usr/bin/env bash

_common_setup() {
    load '../test_helper/bats-support/load'
    load '../test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/../.." >/dev/null 2>&1 && pwd )"
    PROJECT_SRC="$PROJECT_ROOT/src"
    
    source "$PROJECT_SRC/requirements.sh"
    source "$PROJECT_SRC/data/season.sh"

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