#!/usr/bin/env bash
# Auto-todo sync – extracts todo items from memory and stores them in a wiki synthesis

# 1️⃣ Search memory for lines containing "todo" (case-insensitive)
#    We limit to 200 most recent matches to avoid huge output
SEARCH_RESULTS=$(openclaw memory_search "todo" --max-results 200 2>/dev/null)

# 2️⃣ If we got results, format them
if [[ -n "$SEARCH_RESULTS" ]]; then
    # The search output includes metadata lines; we want just the matched snippets.
    # For simplicity, we'll use the raw output (it already shows path and snippet).
    # Optionally, we can clean it up, but raw is fine for a synthesis.
    TODO_TEXT="$SEARCH_RESULTS"
else
    TODO_TEXT="Geen todo-items gevonden in het geheugen."
fi

# 3️⃣ Create/update a wiki synthesis for today's date
DATE=$(date +%Y-%m-%d)
TITLE="Buddy – Todo-lijst ($DATE)"
openclaw wiki apply op=create_synthesis title="$TITLE" body="$TODO_TEXT" sourceIds="memory_search" confidence=1.0

echo "[$DATE] Todo-lijst bijgewerkt: $TITLE"