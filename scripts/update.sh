#!/usr/bin/env bash

set -euo pipefail

# Resolve project root so the script works from any current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# EuroPi Contrib Docs – Update Script
# Syncs ONLY: upstream/software/contrib -> src/content/docs
# Works well with a git submodule at ./upstream

UPSTREAM_URL="https://github.com/Allen-Synthesis/EuroPi.git"
UPSTREAM_DIR="$PROJECT_ROOT/upstream"
UPSTREAM_CONTRIB_DIR="$UPSTREAM_DIR/software/contrib"
DOCS_DIR="$PROJECT_ROOT/src/content/docs"

# Enable ** globbing on macOS' default bash (3.2) as well as newer bash
shopt -s globstar nullglob 2>/dev/null || true

echo "▶ Updating EuroPi contrib documentation site"

# 1) Ensure upstream exists (prefer submodule, fallback to clone)
if [ -d "$UPSTREAM_DIR/.git" ] || [ -f "$UPSTREAM_DIR/.git" ]; then
  # If it's a submodule, .git can be a file pointing elsewhere — both cases are OK.
  echo "▶ Updating upstream repository"
  if [ -f "$PROJECT_ROOT/.gitmodules" ] && git -C "$PROJECT_ROOT" submodule status "upstream" >/dev/null 2>&1; then
    git -C "$PROJECT_ROOT" submodule update --init --remote --merge "upstream"
  else
    git -C "$UPSTREAM_DIR" pull
  fi
else
  echo "▶ Cloning upstream EuroPi repository"
  git clone "$UPSTREAM_URL" "$UPSTREAM_DIR"
fi

# Sanity check
if [ ! -d "$UPSTREAM_CONTRIB_DIR" ]; then
  echo "[ERR] Upstream contrib directory not found: $UPSTREAM_CONTRIB_DIR" >&2
  exit 1
fi

mkdir -p "$DOCS_DIR"
mkdir -p "$PROJECT_ROOT/src/content/i18n"

# 2) Sync Markdown only
echo "▶ Syncing Markdown files"
rsync -av --delete \
  --exclude="home.md" \
  --exclude="README.md" \
  --exclude="code/" \
  --exclude="code/***" \
  --exclude="*-docs/" \
  --exclude="*-docs/***" \
  --include="*/" \
  --include="*.md" \
  --exclude="*" \
  "$UPSTREAM_CONTRIB_DIR/" \
  "$DOCS_DIR/"
# Remove stale files from earlier sync runs that are now excluded
rm -f "$DOCS_DIR/README.md" || true
# Remove stale markdown files that may have been synced previously inside *-docs folders.
# (We exclude *-docs from markdown sync to avoid Starlight id collisions, but rsync won't delete excluded files.)
find "$DOCS_DIR" -type f -path "*/*-docs/*.md" -delete 2>/dev/null || true

# 3) Sync images / assets
echo "▶ Syncing assets"
rsync -av --delete \
  --exclude="home.md" \
  --exclude="README.md" \
  --exclude="code/" \
  --exclude="code/***" \
  --include="*/" \
  --include="*.png" \
  --include="*.jpg" \
  --include="*.jpeg" \
  --include="*.svg" \
  --exclude="*" \
  "$UPSTREAM_CONTRIB_DIR/" \
  "$DOCS_DIR/"

# 4) Normalize code fences (Python -> python) to satisfy Astro expressive-code
# Avoid ** glob expansion (can be slow/huge) by using find + xargs.
# With `set -euo pipefail`, `grep` returns exit code 1 when there are no matches,
# so we explicitly tolerate that case.
if command -v perl >/dev/null 2>&1; then
  echo "▶ Normalizing code fences"

  tmp_list="$(mktemp)"
  # Build a list of markdown files containing a Python code fence
  # (grep returns 1 if no matches; that's not an error for us)
  find "$DOCS_DIR" -type f -name "*.md" -print0 \
    | xargs -0 -n 50 grep -l '^```Python$' 2>/dev/null > "$tmp_list" || true

  count=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    perl -pi -e 's/^```Python$/```python/gm' "$f" || true
    count=$((count + 1))
  done < "$tmp_list"

  rm -f "$tmp_list"
  echo "  ↳ updated ${count} file(s)"
fi

# 5) Cleanup editor artifacts
echo "▶ Cleaning editor artifacts"
find "$DOCS_DIR" -name "*.sb-*" -delete 2>/dev/null || true
find "$DOCS_DIR" -name "*.swp" -delete 2>/dev/null || true

# 6) Generate local landing page (home.md) while keeping the upstream script list up to date
UPSTREAM_INDEX=""
if [ -f "$UPSTREAM_CONTRIB_DIR/README.md" ]; then
  UPSTREAM_INDEX="$UPSTREAM_CONTRIB_DIR/README.md"
elif [ -f "$UPSTREAM_CONTRIB_DIR/index.md" ]; then
  UPSTREAM_INDEX="$UPSTREAM_CONTRIB_DIR/index.md"
fi
LOCAL_INDEX="$DOCS_DIR/home.md"
# Ensure we don't keep an old index.md around that could collide
rm -f "$DOCS_DIR/index.md" || true

echo "▶ Generating landing page (home.md)"
if [ -f "$UPSTREAM_INDEX" ]; then
  {
    cat <<'EOF'
---
title: EuroPi Contrib Docs
slug: /
---

Welcome 👋

This site is a clean, searchable view of the documentation found in the official EuroPi repository under:
`software/contrib`

## What this site is
- A user-friendly way to browse and read contrib script docs
- Content synced from the official EuroPi repository
- Updated regularly as new scripts/docs are merged upstream

## Contributing
Nothing changes 🙂
Please keep contributing to the official EuroPi repo as usual:

- [Contributing guide](https://github.com/Allen-Synthesis/EuroPi/blob/main/contributing.md)
- [Contrib scripts section](https://github.com/Allen-Synthesis/EuroPi/blob/main/contributing.md#contrib-scripts)

---

EOF

    # Append upstream content starting at the packaged scripts section
    awk 'BEGIN{p=0} /List of packaged scripts/{p=1} {if(p) print}' "$UPSTREAM_INDEX" \
      | sed -E \
          -e 's#\(/contributing\.md([^)]+)?\)#(https://github.com/Allen-Synthesis/EuroPi/blob/main/contributing.md\1)#g' \
          -e 's#\(/software/contrib/dcsn2\.md\)#(code/dscn2)#g' \
          -e 's#\(/software/contrib/([A-Za-z0-9_-]+)\.py\)#(code/\1)#g' \
          -e 's#\(/software/contrib/([A-Za-z0-9_-]+)\.md\)#(\1)#g'
  } > "$LOCAL_INDEX"
else
  echo "[WARN] Upstream README.md/index.md not found under: $UPSTREAM_CONTRIB_DIR" >&2
fi

# 6b) Ensure frontmatter titles for Astro/Starlight content collections
# Some upstream contrib docs are plain Markdown without frontmatter.
# Starlight's docs schema requires a `title` in frontmatter.
echo "▶ Ensuring frontmatter titles"

make_title() {
  local base="$1"
  local spaced
  spaced="$(echo "$base" | tr '_-' '  ')"
  echo "$spaced" | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2)}; print}'
}

find "$DOCS_DIR" -type f -name "*.md" ! -path "*/code/*" ! -name "home.md" -print0 | \
  while IFS= read -r -d '' f; do
    base="$(basename "$f" .md)"
    title="$(make_title "$base")"

    first_line="$(head -n 1 "$f" 2>/dev/null || true)"

    # Case A: no frontmatter at all -> prepend minimal frontmatter with title
    if [ "$first_line" != "---" ]; then
      tmp="$(mktemp)"
      {
        echo "---"
        echo "title: $title"
        echo "---"
        echo ""
        cat "$f"
      } > "$tmp"
      mv "$tmp" "$f"
      continue
    fi

    # Case B: frontmatter exists -> ensure it contains a title before the closing ---
    if ! awk 'BEGIN{in=0;found=0} NR==1{in=1;next} in && /^---$/{exit} in && /^title:/{found=1} END{exit(found?0:1)}' "$f"; then
      tmp="$(mktemp)"
      {
        sed -n '1p' "$f"
        echo "title: $title"
        sed -n '2,$p' "$f"
      } > "$tmp"
      mv "$tmp" "$f"
    fi
  done

# 6c) Fix common upstream image link typos (e.g. .png.png)
echo "▶ Fixing common asset path typos"

if command -v perl >/dev/null 2>&1; then
  # Replace duplicated extensions in markdown image paths
  find "$DOCS_DIR" -type f -name "*.md" -print0 \
    | while IFS= read -r -d '' f; do
        perl -pi -e 's/(\.png)\.png\b/$1/g; s/(\.jpg)\.jpg\b/$1/g; s/(\.jpeg)\.jpeg\b/$1/g; s/(\.svg)\.svg\b/$1/g' "$f" || true
      done
fi
  
# 7) Regenerate code pages from upstream Python scripts
CODE_DIR="$DOCS_DIR/code"
mkdir -p "$CODE_DIR"

echo "▶ Regenerating code pages (from .py)"
py_count=0
for py in "$UPSTREAM_CONTRIB_DIR"/*.py; do
  [ -f "$py" ] || continue
  base="$(basename "$py" .py)"
  out="$CODE_DIR/$base.md"
  {
    echo "---"
    echo "title: Code — $base"
    echo "---"
    echo ""
    echo "# $base.py"
    echo ""
    echo '```python'
    cat "$py"
    echo '```'
  } > "$out"
  py_count=$((py_count + 1))
done

echo "  ↳ generated ${py_count} code page(s)"

# 8) Git status summary
echo "▶ Update complete"
git status --short

echo ""
echo "Next:" 
echo "  npm run dev    # preview locally"
echo "  npm run build  # build for production"
