#!/usr/bin/env bash
# Auto wiki sync – captures recent session activity and stores it as a daily synthesis

# 1️⃣ Get the latest chat history (including tool outputs)
HISTORY=$(openclaw sessions_history sessionKey=main limit=200 includeTools=true)

# 2️⃣ Generate a filename based on today’s date
DATE=$(date +%Y-%m-%d)
TITLE="Buddy – Leerpunten $DATE"

# 3️⃣ Create / update a wiki synthesis with the captured text
openclaw wiki apply op=create_synthesis title="$TITLE" body="$HISTORY"

# 4️⃣ Optionally add a short meta‑note about success
echo "[$DATE] Saved session snapshot to wiki synthesis: $TITLE"