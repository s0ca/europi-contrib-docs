#!/usr/bin/env bash
set -e

# ===============================
# EuroPi Docs – Update Script
# ===============================

UPSTREAM_URL="https://github.com/Allen-Synthesis/EuroPi.git"
UPSTREAM_DIR="upstream"
DOCS_DIR="src/content/docs"

echo "▶ Updating EuroPi documentation site"

# 1. Clone upstream repo if not present
if [ ! -d "$UPSTREAM_DIR/.git" ]; then
  echo "▶ Cloning upstream EuroPi repository"
  git clone "$UPSTREAM_URL" "$UPSTREAM_DIR"
else
  echo "▶ Pulling upstream changes"
  git -C "$UPSTREAM_DIR" pull
fi

# 2. Sync Markdown docs
echo "▶ Syncing Markdown files"
rsync -av --delete   "$UPSTREAM_DIR/software/"   "$DOCS_DIR/"   --exclude="*.py"

# 3. Sync images / assets
echo "▶ Syncing assets"
rsync -av --delete   "$UPSTREAM_DIR/software/"   "$DOCS_DIR/"   --include="*/"   --include="*.png"   --include="*.jpg"   --include="*.jpeg"   --include="*.svg"   --exclude="*"

# 4. Normalize code fences (Python -> python)
echo "▶ Normalizing code fences"
perl -pi -e 's/^```Python$/```python/gm' "$DOCS_DIR"/**/*.md || true

# 5. Cleanup editor artifacts
echo "▶ Cleaning editor artifacts"
find "$DOCS_DIR" -name "*.sb-*" -delete || true
find "$DOCS_DIR" -name "*.swp" -delete || true

# 6. Git status summary
echo "▶ Update complete"
git status --short

echo ""
echo "You can now run:"
echo "  npm run dev    # preview locally"
echo "  npm run build  # build for production"
