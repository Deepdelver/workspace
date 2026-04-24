#!/bin/bash
# Hourly git sync script with dynamic timestamp

cd /home/frank/.openclaw/workspaces/workspace

# Add all changes
git add -A

# Check if there's anything to commit
if git diff --staged --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Commit with dynamic timestamp
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M")
git commit -m "Hourly metadata sync: $TIMESTAMP"

# Push to remote
git push origin main
