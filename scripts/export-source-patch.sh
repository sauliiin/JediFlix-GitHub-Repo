#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="$(cd "$ROOT_DIR/.." && pwd)"
ORIGINAL_DIR="${1:-$WORKSPACE_DIR/xbmc-21.3-Omega-original-unteched/xbmc-21.3-Omega}"
MODIFIED_DIR="${2:-$WORKSPACE_DIR/xbmc-21.3-Omega}"
OUTPUT_DIR="${3:-$ROOT_DIR/source-patch}"
PATCH_FILE="$OUTPUT_DIR/jediflix-kodi.patch"

mkdir -p "$OUTPUT_DIR"

if [[ ! -d "$ORIGINAL_DIR" ]]; then
  echo "Original source not found: $ORIGINAL_DIR" >&2
  exit 1
fi

if [[ ! -d "$MODIFIED_DIR" ]]; then
  echo "Modified source not found: $MODIFIED_DIR" >&2
  exit 1
fi

echo "Generating patch..."

set +e
diff -ruN \
  --exclude=build \
  --exclude=.git \
  --exclude=*.apk \
  "$ORIGINAL_DIR" \
  "$MODIFIED_DIR" > "$PATCH_FILE"
status=$?
set -e

if [[ $status -gt 1 ]]; then
  echo "diff failed while generating patch." >&2
  exit $status
fi

echo "Patch written to: $PATCH_FILE"
