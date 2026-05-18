#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: ./livecheck-tap.sh [--bump] <tap> [brew livecheck options...]

Run brew livecheck for all casks in the given tap.

Options:
  --bump      Update outdated casks using `brew bump-cask-pr --write-only`
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
          echo "$1/$token"
        done
  done
}

update_cask() {
  cask=$1
  latest=$2

  brew bump-cask-pr \
    --write-only \
    --no-audit \
    --no-style \
    --version "$latest" \
    "$cask"
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

tap_casks "$tap" | while IFS= read -r cask; do
  echo
  echo "Checking package: $cask"

  livecheck_outdated "$cask" | while IFS= read -r latest; do
    echo 1 > "$found_file"
    latest=$(echo "$latest" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
    echo "=== Updating package: $cask ==="
    echo "Target version: $latest"
    if ! update_cask "$cask" "$latest"; then
      echo "Failed to update $cask" >&2
    fi
  done
done

if [ ! -s "$found_file" ]; then
  echo "No outdated casks found."
fi
