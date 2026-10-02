---
name: race-post
description: Publish a race to Martin's race CV on rudning.dk — a post in _races/ with facts, photos, diploma, Garmin and Strava, written with him in Danish. Use after a race (marathon, cannonball, half marathon, ultra, triathlon), or when he says /race-post, "opdater CV", or wants to add photos or text to an existing race post.
argument-hint: "[folder with material for the race]"
---

# /race-post [folder]

Put one race on the CV at https://rudning.dk/cv/. One run is one race. Talk to
Martin in Danish; the post is in Danish, in his voice.

- **Repo:** `~/Projects/ehmsen.github.io`, the source of truth. Work on `main`.
  Never touch `~/Obsidian/Vault/Websites/ehmsen.github.io`; it is his old copy.
- **Garmin data:** `~/Obsidian/Vault/Coach/data/garmin/activities/`, read only.
- **The optional folder** holds material he gathered already (photos, videos,
  PDFs). Use it as a starting point. Never change it.

What counts: every race he finished, even a small cannonball. A DNF gets no post.

**Privacy:** the Coach vault holds health data. From it, take facts only (time,
distance, splits, Garmin ID, start point). Never its prose.

## 1. Which race, and does a post exist?

```bash
cd ~/Projects/ehmsen.github.io && git pull --ff-only && git status --short
ls _races/ | grep "^$DATE-"
```

Get the date and name from him, or from the folder name (`YYYY-MM-DD - Name`).
If a post exists, this is a **rerun**. Add new photos to the end of the
gallery and new text to the end of the body. Change nothing else unless he
asks. Then skip to step 4.

## 2. Facts

**Garmin.** Find the activity for the date. The ID is in the filename:

```bash
cd ~/Obsidian/Vault/Coach/data/garmin/activities && ls $DATE-*.summary.json
python3 -c "
import json,sys; d=json.load(open(sys.argv[1])); s=d['summaryDTO']
print(d['activityId'], d['activityName'], s.get('distance'), s.get('duration'), s.get('startLatitude'), s.get('startLongitude'))" FILE
```

For a triathlon, use the `multi_sport` file for the embed. Its sibling files
the same day are the legs. If the data has no activity for the date, ask him
for the Garmin link.

**Strava.** Skip it for a triathlon: Strava splits a multisport race into
separate activities, so there is nothing to embed. Put the diploma and the
Garmin multisport embed side by side instead. For every other race, always ask for the embed code: on the activity, Share → Embed. Keep
`data-embed-id` and `data-token`. Since April 2026 an embed without the token
shows "This content is unavailable" (error EEE). Older activities work without it.

**Place.** Most venues come back, so first look for an earlier post from the
same organiser or place, and reuse its `post_code:` and `city:`:

```bash
grep -l -i "$PLACE" _races/*.md | xargs grep -h '^post_code:\|^city:' | sort | uniq -c
```

For a new venue, turn the Garmin start point into a place with OpenStreetMap.
DAWA closed in 2026. OSM's postal codes can be wrong (it gives 5000 for Stige,
which is 5270), so always confirm with him:

```bash
curl -s -A 'rudning.dk race-post' "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$LAT&lon=$LON&zoom=16" | python3 -c "import json,sys; a=json.load(sys.stdin)['address']; print(a.get('postcode'), a.get('city') or a.get('town') or a.get('village'), a.get('suburb'))"
```

Outside Denmark, leave `post_code:` empty and write `city:` like `Boston, MA`.

**Type and distance.** `type:` is one of `Marathon`, `Halvmarathon`, `Ultra`,
`Triathlon`. `distance:` is in km (`42.2`, `21.1`, `50.0`). For a triathlon,
list the legs: `3.8 km, 180 km, 42.2 km`.

## 3. Diploma

**Ask first.** He may still have to download it. Once he says it is ready,
show the candidates and let him pick:

```bash
find ~/Downloads -maxdepth 1 -iname '*.pdf' -newermt $DATE -print0 | xargs -0 ls -t | head -5
```

Also check the folder for `diplom*.pdf`. Read the text with PDFKit, because
nothing else reads PDFs on this Mac. Keep `</dev/null`:

```bash
osascript -l JavaScript .claude/skills/race-post/pdftext.js "$PDF" </dev/null
```

Take the official time from it. For a triathlon, also take the splits and
places. Compare them with Garmin, and say it if they differ by more than a
minute. The diploma's time is the one that goes on the CV.

A diploma can be a photo (JPEG). Copy it as `diplom.jpeg` and show it with
`<img>` where the iframe would be. Do not number it as a gallery photo.

## 4. Media

Photos come from a Photos album named after the race, and from the folder.
Export the album, then number everything into the race's asset folder:

Your Bash tool cannot read the Photos library, and his terminal can. So make
a **new, empty** `$TMP` with Bash for every export (`mktemp -d`). If an earlier
export left its database there, osxphotos waits for a y/N answer you cannot
see, and the export looks hung. Run the export with `run_in_terminal`, as one line:

```bash
osxphotos export "$TMP" --album "$ALBUM" --directory "{folder_album}" --filename "{album_seq:04d(1)}" --convert-to-jpeg --jpeg-ext jpeg --skip-original-if-edited --skip-live --download-missing
```

`run_in_terminal` refuses non-ASCII text, so a name like "København" cannot go
on the command line. Write the command to a script in the scratchpad with Bash,
and run `zsh <script>` in the terminal. `osxphotos albums` lists the albums,
with a count for each. Pass it the exact
name. `{album_seq}` only works together with `--directory "{folder_album}"`.
A photo that is also in other albums lands in those albums' folders too, so pass
only `$TMP/$ALBUM` on. `--download-missing` fetches originals from iCloud, and
that can take minutes. Then, back in Bash:

```bash
.claude/skills/race-post/media.sh assets/posts/$DATE [FOLDER] "$TMP/$ALBUM"
```

`media.sh` continues after the highest number already in the folder. It
converts to JPEG at 1280 px, the same as Photos' "Large" export, and turns
`.mov` into `.mp4` with the HandBrake script. It prints the new `gallery:`
lines and the PDFs it copied. `diplom*.pdf` shows as the diploma. Every other
PDF goes in the "Dokumenter" list.

If osxphotos cannot read the library even in his terminal, it needs Full Disk Access. That
is his setting to change, not yours. Until then he exports by hand from Photos:
JPEG, Large size, sequential filenames, into a folder. You pass that folder
instead of `$TMP`.

No photos is fine. The post then has no `header:` and no `gallery:`, and the
site's default teaser is used.

Ask him which photo is the teaser. Show a few candidates with the Read tool.
The header crops the photo to a wide strip and keeps its vertical middle by
default. If the subject sits higher or lower, set `overlay_position:` under
`header:`, for example `"center 20%"`. Check the preview in a wide window
(1600 px) and in a narrow one (900 px). A portrait photo is cropped much
harder than a landscape one, so prefer landscape for the teaser.

**Files over 50 MB.** GitHub refuses files over 100 MB outside LFS. Track each
one by its exact path, never by extension:

```bash
find assets/posts/$DATE -type f -size +50M -exec git lfs track {} \;
```

## 5. Text

Read two or three recent posts in `_races/` for his voice first. Ask 3–4
short questions: how it went, one moment he remembers, who was there, what he
takes with him. Draft:

- `excerpt:`: one or two sentences.
- `tagline:`: two or three short lines, joined with `<br/>`.
- The body: a short paragraph or two above the gallery.

Show him the draft. Then ask **"Vil du udvide rapporten?"**. Keep adding and
asking until he says no.

## 6. The post

File: `_races/$DATE-<slug>.md`. The slug is lowercase with Danish letters kept,
for example `2026-03-14-høfde-ultra-trail-2026.md`. Write `time` as `"H-MM-SS"`.
The CV pages turn `-` into `:`.

```markdown
---
title: >
    <Race name><br/>
    <year or edition>
date: YYYY-MM-DD
post_code: 5000
city: Odense C
type: Marathon
distance: 42.2
time: "3-12-45"
excerpt: "..."
header:
    teaser: "N.jpeg"
    overlay_image: "N.jpeg"
    overlay_position: "center 50%" # optional; move the crop to the subject
    overlay_filter: 0.3 # same as adding an opacity of 0.5 to a black background
    show_overlay_excerpt: true # Show tagline
tagline: >
    Line one<br/>
    Line two
gallery:
    - 1.jpeg
published: true
---

<body text>

<!-- triathlon only: the splits table -->
|  | Tid | Fart | Samlet | Køn | Aldersgruppe |
|-------|--------|---------|---------|---------|---------|
| Svømning (3.8 km) | ... | ... min/100m | | | |
| T1 | ... | | | | |
| Cykling (180 km) | ... | ... km/t | | | |
| T2 | ... | | | | |
| Løb (42.2 km) | ... | ... min/km | | | |
| Slut | ... | | | | |

{% include gallery.html %}

<!-- only when there are other PDFs -->
**Dokumenter**
- [Boston Marathon Program 2026](/assets/posts/{{ page.date | date: '%Y-%m-%d' }}/boston-marathon-program-2026.pdf)

<iframe src='https://connect.garmin.com/modern/activity/embed/<GARMIN_ID>' width='465' height=548 title='Activity Embed' frameborder="0"></iframe>

<div class="side-by-side-container">
  <div class="side-by-side-item">
    <iframe width="100%" height="100%" src="/assets/posts/{{ page.date | date: '%Y-%m-%d' }}/diplom.pdf"></iframe>
  </div>
  <div class="side-by-side-item">
    {% include strava.html id=<STRAVA_ID> token="<STRAVA_TOKEN>" %}
  </div>
</div>
```

Leave out any block whose material is missing: gallery, Dokumenter, diploma,
Strava.

## 7. Preview, commit, push

Preview locally, and open the page in the browser pane:

```bash
export PATH=/opt/homebrew/bin:$PATH   # Homebrew Ruby 4; gems in vendor/bundle
bundle exec jekyll serve     # http://localhost:4000/races/<DATE>-<slug>/
```

If Jekyll will not run, say so, and ask whether to push without a preview.
That check is the minimum. Either way, confirm that the front matter parses
and that every file in `gallery:` exists.

When he says **ja**, commit only this race and push. The message is
`YYYY-MM-DD <Race name>`:

```bash
git add _races/$FILE assets/posts/$DATE .gitattributes
git commit -m "$DATE <Race name>" && git push
gh run watch "$(gh run list -L1 --json databaseId -q '.[0].databaseId')" --exit-status
```

Report whether the Pages deploy succeeded. If it fails because the site is
too big, stop and tell him. The plan is then to move big files to a GitHub
Release and link them there.
