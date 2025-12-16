#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/Obsidian/Vault/Websites/ehmsen.github.io"
DST="$HOME/Projects/ehmsen.github.io"
EXPORTER="$(dirname "$0")/obsidian-export"

# 1) initial export so Jekyll has something to serve
"$EXPORTER" "$SRC" "$DST"

# 2) start Jekyll
(
  cd "$DST"
  bundle exec jekyll serve
) &

JEKYLL_PID=$!

# 3) watch for changes and re-export
watchexec \
  --shell=none \
  --watch "$SRC" \
  --exts md,markdown,png,jpg,jpeg,webp,avif,gif \
  --restart \
  -- \
  "$EXPORTER" "$SRC" "$DST"

# clean up if watcher exits
kill $JEKYLL_PID || true
