# GitOps Implementation Wiki: ~/k8s-stack with ArgoCD

## Overview
- GitOps repo: `~/k8s-stack` (main branch)
- GitOps tool: ArgoCD
- Target cluster: MicroK8s (context: microk8s)
- Structure: apps/ subfolder contains per-app Kubernetes manifests

## Key Findings
- **Cluster Status**: 1 node (frank-standard-pc-i440fx-piix-1996) Ready; Calico + CoreDNS Running; no LLM deployments found.
- **ArgoCD**: Not yet installed on cluster; repo prepared for GitOps.
- **Apps Directory**: Contains many existing apps; litellm-router added as new app.
- **GitOps Flow**: Commit changes to main branch → ArgoCD detects → Applies manifests to cluster.

## Current Implementation
- **Litellm-Router**: Namespace, Deployment, Service created in apps/litellm-router/ and committed.
- **Next Steps**: Install ArgoCD, create ArgoCD App for litellm-router, and test sync.

## GitOps Best Practices Applied
- Commit all changes before cluster sync.
- Use descriptive commit messages.
- Separate app manifests per directory.
- Use placeholders for images; replace before production.

## Actions Taken
- Verified cluster state with kubectl.
- Created litellm-router manifests in apps/.
- Committed changes to git.
- Documented findings in wiki.

## Next Steps
1. Install ArgoCD on MicroK8s.
2. Create ArgoCD App for litellm-router.
3. Test GitOps sync from repo to cluster.
4. Iterate with real images and config.

## Commands Used
- `kubectl get nodes/deployments/pods -A`
- `git status/commit/push`
- `ls -la ~/k8s-stack/apps/`
- `cat deployment.yaml/service.yaml`

## Risks/Considerations
- ArgoCD not yet installed → manual kubectl apply for now.
- Placeholder image → replace before production.
- Namespace isolation → ensure RBAC if needed.

## Conclusion
- GitOps repo is ready.
- Cluster is healthy.
- ArgoCD installation and app creation are next steps for automated sync.

---
*Always commit changes to ~/k8s-stack before expecting ArgoCD to sync to cluster.*

---

# Home Assistant Troubleshooting - 2026-04-18

## Probleem
Frontend toonde slechts 3 automations terwijl API 120+ toonde. HA in safe mode.

## Oorzaak
1. Duplicate `template:` keys in configuration.yaml (regels 653, 724, 747)
2. Deprecated integraties: `color_extractor:`, `ambient_extractor:`
3. **MAIN FIX**: configuration.yaml laadde slechts 1 bestand i.p.v. hele directory
   - `automation: !include automations.yaml` (1 bestand, 43 regels)
   - Moet zijn: `automation: !include_dir_merge_list automation` (directory)

## Oplossing
1. Deprecated opties uitgecomment in configuration.yaml
2. configuration.yaml fix: `!include_dir_merge_list automation`
3. Backup automations.yaml.bak (74 automations) gekopieerd naar automation/ folder
4. `ha core restart` uitgevoerd

## Resultaat
- API: 76 automations geladen ✅
- Frontend: Toont nu alles ✅

## Leerpunten
- Check altijd `ha core check` bij HA problemen
- Duplicate YAML keys zijn fatal
- Deprecated integraties、及时 verwijderen
- `!include` vs `!include_dir_merge_list` - verschil matters
- backup bestanden bevatten vaak meer automations dan actieve config
- API shows count ≠ frontend count = config problem

---

## Zigbee2MQTT Troubleshooting (2026-04-18)

### Probleem
WC en Gang lampen toonden "unavailable" in Home Assistant.

### Oorzaak
Lampen waren fysiek offline omdat wandschakelaars uit stonden. Check `last_seen` in Zigbee2MQTT state.json:
```bash
ssh root@192.168.1.251 "cat /config/zigbee2mqtt/state.json"
```

### Oplossing
- WC lamp hersteld door `switch.wc_switch_switch_1` aan te zetten via API
- Gang lamp heeft fysieke wandschakelaar nodig

### Leerpunt
Bij "unavailable" Zigbee lampen: altijd eerst fysieke schakelaars controleren.

---

## Home Assistant Config
- URL: https://deepdelver.duckdns.org:8123
- SSH: root@192.168.1.251
- Zigbee2MQTT state: /config/zigbee2mqtt/state.json

## Troubleshooting Les (2026-04-18)
**Regel: Check simpelste oorzaak EERST!**
- Fysieke dingen (schakelaars, stekkers, stroom) vóór netwerk/config issues
- Bij "unavailable" entities: check `last_seen` in device state voordat je hele subsystemen blamed
- Zelfs als andere apparaten werken, kunnen individuele devices offline zijn
- Vooroordeel vermijden: "dit werkt" betekent niet "alles werkt"