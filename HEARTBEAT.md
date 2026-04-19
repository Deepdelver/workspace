# HEARTBEAT.md

# Tasks to run on each heartbeat

- Check for updates to OpenClaw documentation: fetch https://docs.openclaw.ai/llms.txt and compare with local copy; if changed, update wiki synthesis and notify.
- Pull latest changes from git repository in ~/workspace (if any) and commit local changes.
- Run wiki lint and update metadata.
- Run proactive loop check (ensure proactive_loop.sh is running).
# ==== AUTO‑OPTIMIZATION BLOCK (runs every heartbeat) ====

# 1️⃣ Refresh GitOps repo & auto‑commit any drift
cd ~/k8s-stack
git pull --quiet
git diff --quiet && git commit -am "Heartbeat auto‑commit" --quiet || echo "No changes"

# 2️⃣ Lint the wiki (keeps knowledge base clean)
openclaw wiki lint

# 3️⃣ Force ArgoCD to reconcile all apps (ensures GitOps state)
if command -v argocd >/dev/null 2>&1; then
  argocd app sync --all --timeout 300s --wait 2>&1 | head -20
else
  echo "argocd CLI not found, skipping ArgoCD sync"
fi

# 4️⃣ Enforce security policies (exec=allowlist, sandbox=all)
openclaw config set agents.defaults.exec.security="allowlist"
openclaw config set agents.defaults.sandbox.mode="all"

# 5️⃣ Run a health check and surface any alerts
openclaw health --verbose

# 5️⃣⃣ Check OpenClaw logs for errors and run expert agent if needed
if [ -d "/home/frank/.openclaw/logs" ]; then
  if ERRORS=$(grep -i error /home/frank/.openclaw/logs/*.log 2>/dev/null | head -5); then
    echo "Errors found in logs:"
    echo "$ERRORS"
    echo "Triggering expert agent..."
    # Spawn a subagent to fix logs in background so heartbeat doesn't block
    (openclaw sessions_spawn --task "Analyze and fix errors in OpenClaw logs" --label "log-fixer" --runtime subagent) &
  else
    echo "No errors found in logs."
  fi
else
  echo "Logs directory not found."
fi

# 6️⃣ Self‑Research → Wiki pipeline (automatically captures new insights)
if [ -f "~/.openclaw/workspaces/workspace/researcher/auto-wiki-pipeline.sh" ]; then
  ~/.openclaw/workspaces/workspace/researcher/auto-wiki-pipeline.sh
else
  echo "Researcher wiki pipeline script not found."
fi

# 7️⃣ Todo / Scrum integration (parse /todo commands)
openclaw memory_search "todo" --max-results 20 2>/dev/null || true

# 8️⃣ Auto‑todo sync – update wiki synthesis with remaining todo items
/home/frank/.openclaw/workspaces/workspace/auto-todo-sync.sh

# -------------------------------------------------------
