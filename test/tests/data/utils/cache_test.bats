
setup() {
    load '../../../test_helper/common-setup'
    _common_setup "../../../../"
}

teardown() {
    _common_teardown
}

@test "load data if file not found" {
    data=$(cache "" "$season_dir/file_not_found_test.json" 'echo "some data"')
    [ "$data" = 'some data' ]
}

@test "load data if cache expired" {
    file="$season_dir/cache_expired.json"
    echo "expired data" >| "$file"

    data=$(cache "" "$file" 'echo "newer data"' -10)
    [ "$data" = 'newer data' ]
}

@test "load data if INVALIDATE_CACHES" {
    file="$season_dir/invalidate_caches.json"
    echo "current data" >| "$file"

    INVALIDATE_CACHES=1
    data=$(cache "" "$file" 'echo "newer data"')
    [ "$data" = 'newer data' ]
}

@test "load data from cached file" {
    file="$season_dir/cached_file.json"
    echo "current data" >| "$file"

    data=$(cache "" "$file" 'echo "newer data"')
    [ "$data" = 'current data' ]
}

@test "return data var if cache already loaded" {
    file="$season_dir/already_loaded.json"
    echo "current data" >| "$file"

    data=$(cache "loaded data" "$file" 'echo "newer data"')
    [ "$data" = 'loaded data' ]
}