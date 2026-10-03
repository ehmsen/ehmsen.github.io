#!/usr/bin/env bash
# Usage: media.sh DEST SRC...
# Numbers photos and videos from each SRC folder into DEST, continuing after the
# highest number already in DEST, and prints the new gallery lines. Photos become
# JPEG, at most 1280 px on the long edge (Photos' "Large"). .mov, and .mp4 over
# 25 MB, go through assets/posts/convert_mov_to_mp4.sh, run inside DEST only.
# PDFs are copied with a slugged name and printed as "pdf: <name>". Sources are
# never changed.
set -euo pipefail

dest=$1; shift
posts=$(cd "$(dirname "$0")/../../../assets/posts" && pwd)
mkdir -p "$dest"

n=$(find "$dest" -maxdepth 1 -type f | sed -nE 's|.*/([0-9]+)\.[^./]+$|\1|p' | sort -n | tail -1)
n=${n:-0}
movs=0
# Checksums of what DEST holds, so a file met twice (album and folder, or a
# rerun) is copied once. Only exact copies match; converted files do not.
seen=$(find "$dest" -maxdepth 1 -type f ! -name '.*' -exec md5 -q {} \;)

for src in "$@"; do
  while IFS= read -r -d '' f; do
    name=$(basename "$f")
    ext=$(printf '%s' "${name##*.}" | tr '[:upper:]' '[:lower:]')
    h=$(md5 -q "$f")
    if grep -qx "$h" <<<"$seen"; then echo "duplicate: $f" >&2; continue; fi
    seen+=$'\n'$h
    case $ext in
      jpg|jpeg|heic|png)
        n=$((n + 1)); out="$dest/$n.jpeg"
        if [[ $ext == jpg || $ext == jpeg ]]; then cp "$f" "$out"
        else sips -s format jpeg "$f" --out "$out" >/dev/null; fi
        w=$(sips -g pixelWidth "$out" | awk '/pixelWidth/ {print $2}')
        h=$(sips -g pixelHeight "$out" | awk '/pixelHeight/ {print $2}')
        (( w > 1280 || h > 1280 )) && sips -Z 1280 "$out" >/dev/null
        echo "    - $n.jpeg" ;;
      mov)
        n=$((n + 1)); cp "$f" "$dest/$n.mov"; movs=1
        echo "    - $n.mp4" ;;
      mp4)
        # Over 25 MB goes through HandBrake too: named .mov, the script picks it up.
        n=$((n + 1))
        if (( $(stat -f %z "$f") > 25 * 1024 * 1024 )); then cp "$f" "$dest/$n.mov"; movs=1
        else cp "$f" "$dest/$n.mp4"; fi
        echo "    - $n.mp4" ;;
      pdf)
        slug=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | tr ' \302\240' '---' | tr -s '-')
        cp "$f" "$dest/$slug"
        echo "pdf: $slug" ;;
      *) echo "skipped: $f" >&2 ;;
    esac
  done < <(find "$src" -maxdepth 1 -type f ! -name '.*' -print0 | sort -zV)
done

if (( movs )); then
  # The script calls ./HandBrakeCLI and scans ".", so run it from DEST with a
  # temporary link to the binary: other races' .mov files stay untouched.
  ln -sf "$posts/HandBrakeCLI" "$dest/HandBrakeCLI"
  trap 'rm -f "$dest/HandBrakeCLI"' EXIT
  (cd "$dest" && "$posts/convert_mov_to_mp4.sh")
fi
