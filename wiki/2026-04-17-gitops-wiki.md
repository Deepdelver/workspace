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