
function download() {
    wget --header="User-Agent: NBA-CMD" "${2:-}" -q -O - "${1}"
}
