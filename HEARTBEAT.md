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

# 2️⃣ Lint & auto‑fix the wiki (keeps knowledge base clean)
openclaw wiki lint --auto-fix

# 3️⃣ Force ArgoCD to reconcile all apps (ensures GitOps state)
openclaw app sync --all --timeout 300s --wait

# 4️⃣ Enforce security policies (exec=allowlist, sandbox=all)
openclaw config set agents.defaults.exec.security="allowlist" --silent
openclaw config set agents.defaults.sandbox.mode="all" --silent

# 5️⃣ Run a health check and surface any alerts
openclaw health --verbose

# 6️⃣ Self‑Research → Wiki pipeline (automatically captures new insights)
~/.openclaw/workspaces/workspace/researcher/auto-wiki-pipeline.sh

# 7️⃣ Todo / Scrum integration (parse /todo commands)
openclaw memory_search "todo" --max-results 20 || true

# -------------------------------------------------------
