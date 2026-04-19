# HEARTBEAT.md

# Tasks to run on each heartbeat

- Check for updates to OpenClaw documentation: fetch https://docs.openclaw.ai/llms.txt and compare with local copy; if changed, update wiki synthesis and notify.
- Pull latest changes from git repository in ~/workspace (if any) and commit local changes.
- Run wiki lint and update metadata.
- Run proactive loop check (ensure proactive_loop.sh is running).