#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="$(cd "$ROOT_DIR/.." && pwd)"
ORIGINAL_DIR="${1:-$WORKSPACE_DIR/xbmc-21.3-Omega-original-unteched/xbmc-21.3-Omega}"
MODIFIED_DIR="${2:-$WORKSPACE_DIR/xbmc-21.3-Omega}"
OUTPUT_DIR="${3:-$ROOT_DIR/source-patch}"
PATCH_STEM="$OUTPUT_DIR/jediflix-kodi-corresponding-source"
PATCH_FILE="$PATCH_STEM.patch"
PATCH_GZ="$PATCH_FILE.gz"
CHANGED_LIST="$OUTPUT_DIR/changed-files.txt"
REMOVED_LIST="$OUTPUT_DIR/removed-files.txt"
SHA_FILE="$OUTPUT_DIR/SHA256SUMS.txt"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

mkdir -p "$OUTPUT_DIR"

if [[ ! -d "$ORIGINAL_DIR" ]]; then
  echo "Original source not found: $ORIGINAL_DIR" >&2
  exit 1
fi

if [[ ! -d "$MODIFIED_DIR" ]]; then
  echo "Modified source not found: $MODIFIED_DIR" >&2
  exit 1
fi

collect_files() {
  local base_dir="$1"
  local output_file="$2"

  (
    cd "$base_dir"
    find . \
      \( \
        -path './build' -o \
        -path './.git' -o \
        -path './.github' -o \
        -name '__pycache__' -o \
        -name 'autom4te.cache' -o \
        -name '*-linux-native' -o \
        -name '*-release' \
      \) -prune -o \
      -type f \
      ! -name '*.apk' \
      ! -name '*.pyc' \
      ! -name '*.pyo' \
      ! -name '*.log' \
      ! -name 'compile_commands.json' \
      ! -name 'config.log' \
      ! -name 'config.status' \
      ! -name 'configure~' \
      ! -name '.DS_Store' \
      ! -name 'Thumbs.db' \
      ! -name '.installed-*' \
      -printf '%P\n' | sort
  ) > "$output_file"
}

TMP_ORIGINAL_LIST="$TMP_DIR/original-files.txt"
TMP_MODIFIED_LIST="$TMP_DIR/modified-files.txt"
TMP_ALL_LIST="$TMP_DIR/all-files.txt"
TMP_TREE_ROOT="$TMP_DIR/patch-roots"

collect_files "$ORIGINAL_DIR" "$TMP_ORIGINAL_LIST"
collect_files "$MODIFIED_DIR" "$TMP_MODIFIED_LIST"
cat "$TMP_ORIGINAL_LIST" "$TMP_MODIFIED_LIST" | sort -u > "$TMP_ALL_LIST"

mkdir -p "$TMP_TREE_ROOT"
ln -s "$ORIGINAL_DIR" "$TMP_TREE_ROOT/upstream"
ln -s "$MODIFIED_DIR" "$TMP_TREE_ROOT/jediflix"

: > "$PATCH_FILE"
: > "$CHANGED_LIST"
: > "$REMOVED_LIST"

echo "Generating cleaned corresponding-source patch..."

while IFS= read -r rel_path; do
  upstream_file="$ORIGINAL_DIR/$rel_path"
  jediflix_file="$MODIFIED_DIR/$rel_path"
  upstream_ref="upstream/$rel_path"
  jediflix_ref="jediflix/$rel_path"

  if [[ -f "$upstream_file" && -f "$jediflix_file" ]]; then
    if cmp -s "$upstream_file" "$jediflix_file"; then
      continue
    fi

    printf '%s\n' "$rel_path" >> "$CHANGED_LIST"
    (
      cd "$TMP_TREE_ROOT"
      set +e
      git diff --no-index --binary --full-index --no-renames -- "$upstream_ref" "$jediflix_ref"
      status=$?
      set -e
      if [[ $status -gt 1 ]]; then
        exit "$status"
      fi
    ) >> "$PATCH_FILE"
  elif [[ -f "$jediflix_file" ]]; then
    printf '%s\n' "$rel_path" >> "$CHANGED_LIST"
    (
      cd "$TMP_TREE_ROOT"
      set +e
      git diff --no-index --binary --full-index --no-renames -- /dev/null "$jediflix_ref"
      status=$?
      set -e
      if [[ $status -gt 1 ]]; then
        exit "$status"
      fi
    ) >> "$PATCH_FILE"
  elif [[ -f "$upstream_file" ]]; then
    printf '%s\n' "$rel_path" >> "$REMOVED_LIST"
    (
      cd "$TMP_TREE_ROOT"
      set +e
      git diff --no-index --binary --full-index --no-renames -- "$upstream_ref" /dev/null
      status=$?
      set -e
      if [[ $status -gt 1 ]]; then
        exit "$status"
      fi
    ) >> "$PATCH_FILE"
  fi
done < "$TMP_ALL_LIST"

gzip -9 -c "$PATCH_FILE" > "$PATCH_GZ"
rm -f "$PATCH_FILE"
(
  cd "$OUTPUT_DIR"
  sha256sum "$(basename "$PATCH_GZ")"
) > "$SHA_FILE"

echo "Patch written to: $PATCH_GZ"
echo "Changed-file manifest written to: $CHANGED_LIST"
echo "Removed-file manifest written to: $REMOVED_LIST"
echo "SHA256 summary written to: $SHA_FILE"
