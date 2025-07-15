#!/bin/bash
# Sync documentation from Marcus and Seneca repositories

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$ROOT_DIR/docs"

echo "🔄 Syncing documentation from source repositories..."

# Create directories if they don't exist
mkdir -p "$DOCS_DIR/marcus" "$DOCS_DIR/seneca"

# Sync Marcus documentation
if [ -d "/Users/lwgray/dev/marcus/docs" ]; then
    echo "📦 Syncing Marcus documentation..."
    rsync -av --delete \
        --exclude='.git' \
        --exclude='_build' \
        --exclude='__pycache__' \
        "/Users/lwgray/dev/marcus/docs/" "$DOCS_DIR/marcus/"
    echo "✅ Marcus documentation synced"
else
    echo "⚠️  Marcus repository not found at /Users/lwgray/dev/marcus"
fi

# Sync Seneca documentation
if [ -d "/Users/lwgray/dev/seneca/docs" ]; then
    echo "📦 Syncing Seneca documentation..."
    rsync -av --delete \
        --exclude='.git' \
        --exclude='_build' \
        --exclude='__pycache__' \
        "/Users/lwgray/dev/seneca/docs/" "$DOCS_DIR/seneca/"
    
    # Convert RST files to Markdown if needed
    echo "🔄 Converting RST files to Markdown..."
    find "$DOCS_DIR/seneca" -name "*.rst" | while read -r rst_file; do
        md_file="${rst_file%.rst}.md"
        echo "Converting: $rst_file -> $md_file"
        # For now, just copy as-is. In production, use pandoc:
        # pandoc -f rst -t markdown -o "$md_file" "$rst_file"
        cp "$rst_file" "$md_file" 2>/dev/null || true
    done
    
    echo "✅ Seneca documentation synced"
else
    echo "⚠️  Seneca repository not found at /Users/lwgray/dev/seneca"
fi

# Update cross-references
echo "🔗 Updating cross-references..."
find "$DOCS_DIR" -name "*.md" -type f | while read -r file; do
    # Update Marcus internal links
    sed -i '' 's|\](systems/|\](marcus/systems/|g' "$file" 2>/dev/null || true
    sed -i '' 's|\](api/|\](marcus/api/|g' "$file" 2>/dev/null || true
    
    # Update Seneca internal links  
    sed -i '' 's|\](../systems/|\](seneca/systems/|g' "$file" 2>/dev/null || true
done

echo "✨ Documentation sync complete!"