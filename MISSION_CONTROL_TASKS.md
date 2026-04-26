# Mission Control Tasks - Agent Optimization & Multi-Agent Patterns

Taken afgeleid van onderzoek naar agent instructies optimalisatie en multi-agent collaboration.

## Taak 1: Optimaliseer SOUL.md
**Prioriteit**: Hoog
**Project**: General (1) of Nutriguard (2)
**Beschrijving**:
- Verkort SOUL.md tot kernpunten (momenteel 595 woorden)
- Verwijder uitgebreide uitleg, behoud kernwaarden
- Split Nederlandse/Engelse instructies
- Voorbeeld nieuwe structuur:
  ```markdown
  ## Kernwaarden
  - Direct helpen, geen "Great question!"
  - Nederlands spreken
  - Zelf uitzoeken eerst, dan pas vragen
  - Uitvoeren + controleren + tonen
  ```

## Taak 2: Stroomlijn AGENTS.md
**Prioriteit**: Hoog
**Beschrijving**:
- Verkort AGENTS.md (momenteel 1364 woorden)
- Verwijder dubbele regels en overbodige voorbeelden
- Focus op essentiële instructies en grenzen
- Houd alleen de belangrijkste richtlijnen

## Taak 3: Maak Workflow Skill
**Prioriteit**: Medium
**Beschrijving**:
- Verplaats standaard workflow naar `~/.openclaw/workspaces/workspace/skills/workflow/SKILL.md`
- Bevat: memory_search + wiki_search, check skills/tools, lees docs, subagents, oplossen + verifieer, wiki update
- Verminder token usage per sessie

## Taak 4: Overweeg Multi-Agent Setup
**Prioriteit**: Medium
**Beschrijving**:
- Evalueer of specialistische agents gewenst zijn (k8s-specialist, HA-specialist)
- Mogelijke configuratie:
  ```json5
  {
    agents: {
      list: [
        { id: "buddy", workspace: "~/workspace" },
        { id: "k8s-specialist", skills: ["kubectl", "argocd"] },
        { id: "ha-specialist", skills: ["home-assistant"] }
      ]
    }
  }
  ```
- Of behoud huidige opzet (single agent + subagents)

## Taak 5: Token Optimization
**Prioriteit**: Medium
**Beschrijving**:
- Gebruik `sessions_spawn` voor lange contexten
- Per-agent skill allowlists in config (`agents.list[].skills`)
- Korte, krachtige instructies in SOUL.md
- Overweeg `compact` mode indien beschikbaar

## Taak 6: Wiki Update & Lint
**Prioriteit**: Laag
**Beschrijving**:
- Voer `openclaw wiki lint --auto-fix` uit na wijzigingen
- Compileer wiki met `openclaw wiki compile` na bulkwijzigingen
-Update wiki met nieuwe inzichten over agent optimization

## Referenties
- Wiki pagina: `syntheses/agent-instructions-optimization-multi-agent-patterns.md`
- OpenClaw docs: https://docs.openclaw.ai/concepts/multi-agent
- OpenClaw docs: https://docs.openclaw.ai/tools/skills

## Status
- [ ] Te doen
- [ ] In uitvoering
- [x] Voltooid

## Notities
- Mission Control deployment bezig (namespace aangemaakt, pods starten)
- API endpoint: https://mission-control.deeps-home.duckdns.org/api/tasks
- API key beschikbaar in mission-control skill
