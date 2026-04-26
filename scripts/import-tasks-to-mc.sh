#!/bin/bash
# Script to import tasks from MISSION_CONTROL_TASKS.md to Mission Control API
# Usage: bash import-tasks-to-mc.sh

API_KEY="d9679c2e15e4b5f01df519a2ad415d5b086363e4e57e2eb53ebc4cde6a1718fb"
API_BASE="https://mission-control.deeps-home.duckdns.org"

# Task 1: Optimize SOUL.md
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Optimaliseer SOUL.md",
    "description": "Verkort instructies (595 woorden), verplaats procedures naar skills, focus op kernwaarden.",
    "priority": "high",
    "project_id": 2
  }'

# Task 2: Streamline AGENTS.md
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Stroomlijn AGENTS.md",
    "description": "Verkort van 1364 woorden, verwijder dubbelingen, focus op essentiële instructies.",
    "priority": "high",
    "project_id": 2
  }'

# Task 3: Create workflow skill
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Maak workflow skill",
    "description": "Verplaats standaard workflow naar skills/workflow/SKILL.md. Verminder token usage per sessie.",
    "priority": "medium",
    "project_id": 2
  }'

# Task 4: Consider multi-agent setup
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Overweeg multi-agent setup",
    "description": "Evalueer specialistische agents (k8s-specialist, HA-specialist) vs huidige hierarchical setup.",
    "priority": "medium",
    "project_id": 2
  }'

# Task 5: Token optimization
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Token optimization",
    "description": "Gebruik sessions_spawn voor lange contexten, per-agent skill allowlists, korte instructies.",
    "priority": "medium",
    "project_id": 2
  }'

# Task 6: Wiki lint & compile
curl -s -X POST "${API_BASE}/api/tasks" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Wiki lint & compile",
    "description": "Voer openclaw wiki lint --auto-fix uit na wijzigingen. Compileer wiki na bulkwijzigingen.",
    "priority": "low",
    "project_id": 2
  }'

echo "Tasks imported to Mission Control. Check https://mission-control.deeps-home.duckdns.org"
