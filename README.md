# NBA-CMD
[![CI](https://github.com/c0deWranglr/NBA-CMD/actions/workflows/build.yaml/badge.svg)](https://github.com/c0deWranglr/NBA-CMD/actions/workflows/build.yaml)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/c0dewranglr/NBA-CMD)

WIP. A command-line utility for viewing nba stats

## Downloading

### Latest Version
```
 > curl -s https://api.github.com/repos/c0dewranglr/NBA-CMD/releases/latest \
 | grep "nbac" \
 | cut -d : -f 2,3 \
 | tr -d \" \
 | wget -qi -O /usr/local/bin/nbac -
```

### Download Specific Version
```
> wget -q -O /usr/local/bin/nbac https://github.com/c0deWranglr/NBA-CMD/releases/download/v0.0.3/nbac
```

### Make Executable
```
> chmod 755 /usr/local/bin/nbac
```
Adjust permissions to your liking.
