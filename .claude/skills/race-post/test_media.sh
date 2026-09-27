#!/usr/bin/env bash
# Self-check for media.sh: numbering continues, order is numeric, big photos
# shrink, PNG becomes JPEG, PDFs are slugged, dotfiles are ignored.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
mkdir "$t/dest" "$t/src"
sample=$(find "$here/../../../assets/posts" -name '*.jpeg' -size +500k -print -quit)

cp "$sample" "$t/dest/1.jpeg"; cp "$sample" "$t/dest/2.jpeg"
sips -Z 2000 "$sample" --out "$t/src/10.jpeg" >/dev/null
sips -s format png "$sample" --out "$t/src/2.png" >/dev/null
echo x > "$t/src/.DS_Store"
echo x > "$t/src/Boston Program 2026.pdf"

out=$("$here/media.sh" "$t/dest" "$t/src")
expected=$'    - 3.jpeg\n    - 4.jpeg\npdf: boston-program-2026.pdf'
[[ $out == "$expected" ]] || { echo "FAIL output:"; echo "$out"; exit 1; }
w=$(sips -g pixelWidth -g pixelHeight "$t/dest/4.jpeg" | awk '/pixel/ {print $2}' | sort -n | tail -1)
[[ $w -le 1280 ]] || { echo "FAIL: 4.jpeg is $w px"; exit 1; }
[[ $(sips -g format "$t/dest/3.jpeg" | awk '/format/ {print $2}') == jpeg ]] || { echo "FAIL: 3 not jpeg"; exit 1; }
echo OK
