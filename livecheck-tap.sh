#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: ./livecheck-tap.sh [--bump] [--checksum-only] [--only <cask>] <tap> [brew livecheck options...]

Run brew livecheck for all casks in the given tap.

Options:
  --bump           Update outdated casks using `brew bump-cask-pr --write-only`
  --checksum-only  Update checksums for current cask versions only
  --only <cask>    Only check and update the given cask with --bump or --checksum-only
  -h, --help       Show this help text

Examples:
  ./livecheck-tap.sh dasbaumwolltier/unsigned-casks
  ./livecheck-tap.sh homebrew/cask
  ./livecheck-tap.sh dasbaumwolltier/unsigned-casks --newer-only
  ./livecheck-tap.sh --bump dasbaumwolltier/unsigned-casks
  ./livecheck-tap.sh --bump --only foo dasbaumwolltier/unsigned-casks
  ./livecheck-tap.sh --checksum-only --only foo dasbaumwolltier/unsigned-casks
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

cask_version() {
  brew info --cask --json=v2 "$1" \
    | ruby -rjson -e 'puts JSON.parse(STDIN.read).fetch("casks").fetch(0).fetch("version")'
}

bump=false
checksum_only=false
only=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bump)
      bump=true
      shift
      ;;
    --checksum-only)
      checksum_only=true
      shift
      ;;
    --only)
      if [ "$#" -lt 2 ]; then
        echo "error: --only requires a cask" >&2
        exit 1
      fi
      only=$2
      shift 2
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

if [ "$bump" = true ] && [ "$checksum_only" = true ]; then
  echo "error: --bump and --checksum-only cannot be used together" >&2
  exit 1
fi

if [ -n "$only" ]; then
  case "$only" in
    */*) ;;
    *) only="$tap/$only" ;;
  esac
fi

if [ "$bump" = false ] && [ "$checksum_only" = false ]; then
  if [ -n "$only" ]; then
    echo "error: --only is only supported with --bump or --checksum-only" >&2
    exit 1
  fi
  exec brew livecheck --tap "$tap" --newer-only --cask "$@"
fi

if [ "$#" -gt 0 ]; then
  echo "error: extra brew livecheck options are not supported with --bump or --checksum-only" >&2
  exit 1
fi

found_file=$(mktemp)
trap 'rm -f "$found_file"' EXIT INT TERM HUP

echo "Scanning tap: $tap"

if [ "$checksum_only" = true ]; then
  echo "Updating checksums only."
fi

if [ -n "$only" ]; then
  printf '%s\n' "$only"
else
  tap_casks "$tap"
fi | while IFS= read -r cask; do
  echo
  echo "Checking package: $cask"

  if [ "$checksum_only" = true ]; then
    echo 1 > "$found_file"
    latest=$(cask_version "$cask")
    echo "=== Updating checksum: $cask ==="
    echo "Target version: $latest"
    if ! update_cask "$cask" "$latest"; then
      echo "Failed to update $cask" >&2
    fi
    continue
  fi

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
  if [ "$checksum_only" = true ]; then
    echo "No casks found."
  else
    echo "No outdated casks found."
  fi
fi
