#!/usr/bin/env bash
set -euo pipefail

# EuroPi Contrib Docs – Update Script
# Syncs ONLY: upstream/software/contrib -> src/content/docs
# Works well with a git submodule at ./upstream

UPSTREAM_URL="https://github.com/Allen-Synthesis/EuroPi.git"
UPSTREAM_DIR="upstream"
UPSTREAM_CONTRIB_DIR="$UPSTREAM_DIR/software/contrib"
DOCS_DIR="src/content/docs"

# Enable ** globbing on macOS' default bash (3.2) as well as newer bash
shopt -s globstar nullglob 2>/dev/null || true

echo "▶ Updating EuroPi contrib documentation site"

# 1) Ensure upstream exists (prefer submodule, fallback to clone)
if [ -d "$UPSTREAM_DIR/.git" ] || [ -f "$UPSTREAM_DIR/.git" ]; then
  # If it's a submodule, .git can be a file pointing elsewhere — both cases are OK.
  echo "▶ Updating upstream repository"
  if [ -f .gitmodules ] && git submodule status "$UPSTREAM_DIR" >/dev/null 2>&1; then
    git submodule update --init --remote --merge "$UPSTREAM_DIR"
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

# 2) Sync Markdown only (avoid copying everything twice)
echo "▶ Syncing Markdown files"
rsync -av --delete \
  --include="*/" \
  --include="*.md" \
  --exclude="*" \
  "$UPSTREAM_CONTRIB_DIR/" \
  "$DOCS_DIR/"

# 3) Sync images / assets
echo "▶ Syncing assets"
rsync -av --delete \
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

# 6) Git status summary
echo "▶ Update complete"
git status --short

echo ""
echo "Next:" 
echo "  npm run dev    # preview locally"
echo "  npm run build  # build for production"
