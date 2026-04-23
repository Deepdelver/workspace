# HEARTBEAT.md

# System maintenance heartbeat
# Runs every 15-30 minutes (as configured)
# Performs cleanup, health monitoring, cluster GitOps sync, log fixing, wiki upkeep, and MC system monitoring.

# ==== SYSTEM MAINTENANCE ====

# 1️⃣ Cleanup temporary files (optional, safe)
find /tmp -type f -name "openclaw_*" -mtime +1 -delete 2>/dev/null || true
find ~/.openclaw/cache -type f -mtime +1 -delete 2>/dev/null || true

# 2️⃣ Health check
openclaw health --verbose

# 3️⃣ Cluster health (GitOps + MCP)
cd /home/frank/k8s-stack || { echo "k8s-stack not found"; exit 1; }
git pull --quiet

# Check ArgoCD status
argocd app list -o name 2>/dev/null | while read -r app; do
  if [ -n "$app" ]; then
    status=$(argocd app status $app)
    if [[ $status != *"OK"* ]]; then
      echo "Cluster issue detected in app: $app"
      # Create MC task for repo cleanup
      openclaw sessions_spawn --task "Fix cluster issue in ${app}" --label "pm-task" --runtime subagent
    fi
  fi
done

# 4️⃣ MCporter-based repo/tool health checks
if command -v mcporter >/dev/null 2>&1; then
  errors=$(mcporter list | grep -i "error" || true)
  if [ -n "$errors" ]; then
    echo "MCporter errors detected:"$errors
    openclaw sessions_spawn --task "Fix MCP issues" --label "pm-task" --runtime subagent
  fi
fi

# 5️⃣ Log scanning and alerting
LOG_DIR="/home/frank/.openclaw/logs"
if [ -d "$LOG_DIR" ]; then
  ERRORS=$(grep -i -E "error|fail|panic" "$LOG_DIR"/* 2>/dev/null | head -10)
  if [ -n "$ERRORS" ]; then
    echo "Errors detected in OpenClaw logs:"$ERRORS
    openclaw sessions_spawn --task "Analyze and fix errors in OpenClaw logs" --label "log-expert" --runtime subagent
  fi
fi

# ==== AUTOMATED PROBLEM RESPONSE ====

# When PM tasks are created:
# - Spawn PM agent with specific tasks
# - Use mcporter commands for:
#   - Repo health checks
#   - Model configuration
#   - Agent management

# Example PM task handling:
# openclaw sessions_spawn --agentId pm-subagent --task "Fix repo issue" --label "pm-sub" --runtime subagent