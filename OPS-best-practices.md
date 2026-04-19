# OpenClaw Best Practices Reference

## Security & Hardening

| # | Recommendation | Why it matters | Command |
|---|----------------|----------------|---------|
| 1 | **Restrict Control‑UI origins** – replace `*` with your exact UI URL. | Prevents CSRF attacks from any site. | `openclaw config set gateway.controlUi.allowedOrigins="https://my-control-ui.example.com"` |
| 2 | **Disable insecure auth toggle** (`allowInsecureAuth`). | Guarantees TLS/device‑auth is enforced. | `openclaw config set gateway.controlUi.allowInsecureAuth=false` |
| 3 | **Turn off device‑auth disabling** (`dangerouslyDisableDeviceAuth`). | Stops anyone with UI access from impersonating you. | `openclaw config set gateway.controlUi.dangerouslyDisableDeviceAuth=false` |
| 4 | **Set mDNS to minimal/off**. | Stops leaking host‑metadata on the local network. | `openclaw config set discovery.mdns.mode="minimal"` |
| 5 | **Limit exec‑tool security** – change from `full` to `allowlist`. | Reduces impact of a compromised chat message. | `openclaw config set agents.defaults.exec.security="allowlist"` |
| 6 | **Restrict Telegram group policy** – `allowlist` with explicit IDs. | Only trusted users can trigger exec/elevated tools. | `openclaw config set channels.telegram.groupPolicy="allowlist"`<br>`openclaw config set channels.telegram.groupAllowFrom="[YOUR_TG_ID]"` |
| 7 | **Enable auth rate‑limiting**. | Thwarts brute‑force login attempts. | `openclaw config set gateway.auth.rateLimit='{"maxAttempts":10,"windowMs":60000,"lockoutMs":300000}'` |
| 8 | **Remove plain‑text gateway password** → use env var `OPENCLAW_GATEWAY_PASSWORD`. | Secrets never touch disk. | `openclaw config unset gateway.auth.password`<br>`export OPENCLAW_GATEWAY_PASSWORD="••••"` |
| 9 | **Apply OpenClaw's built‑in security fix** (single‑step). | Runs all safe fixes from the audit in one go. | `openclaw security audit --fix` |
| 10 | **Enable firewall** (UFW for Ubuntu/Debian, pf for macOS). | Blocks unwanted inbound ports. | `ufw enable && ufw default deny incoming && ufw allow ssh && ufw allow 8080/tcp` (adjust ports) |

## Model & Agent Configuration

| Setting | Current Value | Recommended |
|---------|---------------|-------------|
| `use_memory_wiki` | **true** (set) | ✅ Keep – forces every reasoning step to consult the wiki first. |
| `auto_continue_steps` | **true** (set) | ✅ Keep – enables proactive tasks without asking. |
| Model fallback hierarchy | DeepSeek → OpenRouter free → others | ✅ Good. For **critical code** use a higher‑tier model (e.g., `deepseek-reasoner` or `gemma‑4‑31b‑it`). |
| `sandbox` mode for exec‑enabled agents | `off` | **Consider** `agents.defaults.sandbox.mode="all"` if you keep exec tools reachable from public groups (adds an extra isolation layer). |
| `toolsAllow` for cron jobs | `exec,read,write` | ✅ Minimal; add `git` only when needed. |

## Cron & Automation

| Task | Cron expression / helper | Description |
|------|--------------------------|-------------|
| **Hourly Git‑sync** (already created) | `every 1h` | Commits any local change and pushes to remote. |
| **Daily health audit** | `0 3 * * *` | Runs `openclaw security audit --deep` and sends a summary. |
| **Weekly wiki lint** | `0 4 * * 0` | Runs `wiki_lint && wiki_apply op=update_metadata` to keep the vault clean. |
| **Monthly model‑cost report** | `0 5 1 * *` | Executes `openclaw usage --summary` (or a custom script) and emails/announces the report. |

## Memory‑Wiki Usage

1. **Always query the wiki before any decision** – keep the `"use_memory_wiki": true` flag.  
2. **Add new knowledge** via the `wiki_apply` skill; never edit markdown manually.  
3. **Run `wiki_lint` after bulk updates** (can be part of the weekly cron).  
4. **Keep a “known‑issues” synthesis page** (`syntheses/known-issues.md`) – the proactive loop automatically appends new findings.  

## Git Workflow & Backups

| Step | Command | Rationale |
|------|---------|-----------|
| **Set remote** (if missing) | `git remote add origin <git‑url>` | Allows the hourly push to succeed. |
| **Signed commits** (optional) | `git config --global commit.gpgsign true` | Guarantees tamper‑evidence. |
| **Pre‑commit hook** (lint) | Place a hook under `.git/hooks/pre-commit` that runs `wiki_lint && openclaw lint`. | Prevents committing broken wiki pages. |
| **Daily backup** (cron) | `tar -czf ~/backups/openclaw-$(date +%F).tar.gz ~/.openclaw` | Protects against accidental data loss. |

## Logging & Monitoring

- **Enable session logging** (`openclaw session log --enable`).  
- **Watch the cron run history**: `openclaw cron runs --name hourly-git-sync`.  
- **Set up alerts** on critical cron failures: add `--best-effort-deliver false` so a failure will raise a notification.  

## Skill Management

| Skill | When to use | How to invoke |
|-------|-------------|---------------|
| **healthcheck** | Periodic host hardening audit | `openclaw healthcheck` (or via `sessions_spawn runtime:acp …`) |
| **git‑ops** | Managing K8s manifests | `openclaw git‑ops …` (use the skill's `SKILL.md` for exact flags) |
| **free‑models** | Switching to a cost‑free model | `openclaw config set model deepseek-chat` (or invoke via `openclaw ask … --model deepseek-chat`) |
| **wiki‑maintainer** | Bulk wiki edits, synthesis creation | `openclaw wiki_apply …` |
| **summarize** | Turning long articles into concise notes | `openclaw summarize <url>` |

## Next Steps

1. **Approve security fixes** (items 1‑9 under *Security & Hardening*) – batch‑apply them now.  
2. **Add the missing cron jobs** (daily health audit, weekly wiki lint, monthly cost report).  
3. **Create a pre‑commit hook** for wiki linting.  
4. **Set a remote** for the Git repo if you intend to push elsewhere.  
5. **Enable sandbox mode** for exec‑enabled agents (optional but recommended).