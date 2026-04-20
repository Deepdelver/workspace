#!/usr/bin/env bash
# Auto-todo sync – extracts todo items from memory and stores them in a wiki synthesis

# 1️⃣ Search memory for lines containing "todo" (case-insensitive)
#    We limit to 200 most recent matches to avoid huge output
SEARCH_RESULTS=$(openclaw memory_search "todo" --max-results 200 2>/dev/null)

# 2️⃣ If we got results, format them
if [[ -n "$SEARCH_RESULTS" ]]; then
    TODO_TEXT="$SEARCH_RESULTS"
else
    TODO_TEXT="Geen todo-items gevonden in het geheugen."
fi

# 3️⃣ Create/update a wiki synthesis for today's date
DATE=$(date +%Y-%m-%d)
TITLE="Buddy – Todo-lijst ($DATE)"
openclaw wiki apply synthesis --body "$TODO_TEXT" --source-id memory_search --confidence 1.0 "$TITLE"

echo "[$DATE] Todo-lijst bijgewerkt: $TITLE"