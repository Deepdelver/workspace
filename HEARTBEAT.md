# HEARTBEAT.md

# System maintenance heartbeat
# Runs every 15-30 minutes (as configured)
# Performs cleanup, health monitoring, cluster GitOps sync, log fixing, and wiki upkeep.

# ==== SYSTEM MAINTENANCE ====

# 1️⃣ Cleanup temporary files (optional, safe)
find /tmp -type f -name "openclaw_*" -mtime +1 -delete 2>/dev/null || true
find ~/.openclaw/cache -type f -mtime +1 -delete 2>/dev/null || true

# 2️⃣ Health check
openclaw health --verbose

# ==== CLUSTER AGENT (GitOps) ====

# 3️⃣ Ensure we are in the GitOps repo
cd /home/frank/k8s-stack || { echo "k8s-stack not found"; exit 1; }

# Pull latest changes (if any)
git pull --quiet

# Commit any local changes (including auto-commit from previous heartbeat)
if ! git diff --quiet; then
    git add -A
    git commit -m "Heartbeat auto‑commit: $(date +%Y-%m-%d\ %H:%M)"
    git push origin main
else
    echo "No changes to commit in k8s-stack"
fi

# Force ArgoCD sync (if CLI available)
if command -v argocd >/dev/null 2>&1; then
    echo "Syncing ArgoCD applications..."
    # List all apps and sync each individually (compatible with all versions)
    argocd app list -o name 2>/dev/null | while read -r app; do
        if [ -n "$app" ]; then
            echo "Syncing $app..."
            argocd app sync "$app" 2>&1 | head -5
        fi
    done
else
    echo "ArgoCD CLI not installed; skipping sync"
fi

# ==== LOGS & EXPERT AGENT ====

# 4️⃣ Scan OpenClaw logs for errors and trigger expert agent if needed
LOG_DIR="/home/frank/.openclaw/logs"
if [ -d "$LOG_DIR" ]; then
    ERRORS=$(grep -i -E "error|fail|panic" "$LOG_DIR"/*.log 2>/dev/null | head -10)
    if [ -n "$ERRORS" ]; then
        echo "Errors detected in OpenClaw logs:"
        echo "$ERRORS"
        echo "Spawning expert agent to analyze and fix..."
        # Spawn a subagent in background so heartbeat continues
        (openclaw sessions_spawn --task "Analyze and fix errors in OpenClaw logs" --label "log-expert" --runtime subagent) &
    else
        echo "No errors found in OpenClaw logs."
    fi
else
    echo "Log directory not found: $LOG_DIR"
fi

# ==== WIKI MAINTENANCE ====

# 5️⃣ Keep the wiki well‑structured
echo "Running wiki lint..."
openclaw wiki lint

# Optional: update wiki metadata (if needed)
# openclaw wiki apply op=update_metadata ... (handled by other scripts)

# 6️⃣ Auto‑todo sync – keep todo items in wiki synthesis
/home/frank/.openclaw/workspaces/workspace/auto-todo-sync.sh

# 7️⃣ Self‑Research → Wiki pipeline (if available)
if [ -f "/home/frank/.openclaw/workspaces/workspace/researcher/auto-wiki-pipeline.sh" ]; then
    /home/frank/.openclaw/workspaces/workspace/researcher/auto-wiki-pipeline.sh
else
    echo "Researcher wiki pipeline script not found."
fi

echo "Heartbeat completed at $(date)"