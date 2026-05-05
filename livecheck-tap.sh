#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: ./livecheck-tap.sh [--bump] <tap> [brew livecheck options...]

Run brew livecheck for all casks in the given tap.

Options:
  --bump      Update outdated casks by editing the local cask file version
  -h, --help  Show this help text

Examples:
  ./livecheck-tap.sh dasbaumwolltier/unsigned-casks
  ./livecheck-tap.sh homebrew/cask
  ./livecheck-tap.sh dasbaumwolltier/unsigned-casks --newer-only
  ./livecheck-tap.sh --bump dasbaumwolltier/unsigned-casks
EOF
}

livecheck_outdated() {
  brew livecheck --cask --quiet --full-name --newer-only "$1" \
    | grep -v "curl" \
    | awk -F':|==>' '{ print $3 }'
}

tap_casks() {
  brew --repo "$1" | while IFS= read -r repo; do
    find "$repo/Casks" -name '*.rb' -type f \
      | sort \
      | while IFS= read -r file; do
          token=$(basename "$file" .rb)
          echo "$1/$token;$file"
        done
  done
}

update_cask_version() {
  cask=$1
  file=$2
  latest=$3

  version_count=$(grep -c '^[[:space:]]*version[[:space:]]*"' "$file")
  if [ "$version_count" -ne 1 ]; then
    echo "Skipping $cask: expected exactly one quoted version stanza, found $version_count" >&2
    return 1
  fi

  current=$(awk -F'"' '/^[[:space:]]*version[[:space:]]*"/ { print $2; exit }' "$file")
  if [ -z "$current" ]; then
    echo "Skipping $cask: could not read current version" >&2
    return 1
  fi

  tmp_file=$(mktemp)
  awk -v current="$current" -v latest="$latest" '
    done == 0 && $0 ~ /^[[:space:]]*version[[:space:]]*"/ {
      sub(/"[^"]*"/, "\"" latest "\"")
      done = 1
    }
    { print }
  ' "$file" > "$tmp_file"
  mv "$tmp_file" "$file"
}

bump=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bump)
      bump=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      break
      ;;
    *)
      break
      ;;
  esac
done

if [ "$#" -lt 1 ]; then
  usage >&2
  exit 1
fi

tap=$1
shift

if [ "$bump" = false ]; then
  exec brew livecheck --tap "$tap" --newer-only --cask "$@"
fi

if [ "$#" -gt 0 ]; then
  echo "error: extra brew livecheck options are not supported with --bump" >&2
  exit 1
fi

found_file=$(mktemp)
trap 'rm -f "$found_file"' EXIT INT TERM HUP

echo "Scanning tap: $tap"

tap_casks "$tap" | while IFS=';' read -r cask file; do
  echo
  echo "Checking package: $cask"

  livecheck_outdated "$cask" | while read -r latest; do
    echo "newer version for $cask $latest"
    echo 1 > "$found_file"
    latest=$(echo "$latest" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    echo "=== Updating package: $cask ==="
    echo "Target version: $latest"
    if ! update_cask_version "$cask" "$file" "$latest"; then
      echo "Failed to update $cask" >&2
    fi
  done
done

if [ ! -s "$found_file" ]; then
  echo "No outdated casks found."
fi
