# Research: ~/k8s-stack and kubectl verification (MicroK8s)

## Cluster Verification
- Node: frank-standard-pc-i440fx-piix-1996 — Ready (v1.33.9)
- Addons: dns, ha-cluster, helm, helm3 enabled
- Namespaces: default, kube-node-lease, kube-public, kube-system + custom (openclaw, etc.)
- Core services: Calico (node/controllers), CoreDNS Running

## Apps Overview (~/k8s-stack/apps/)
- 42+ applications (a2a-client, a2a-server, cert-manager, code-server-app, crossplane, duckdns, gpu-operator-resources, gpustack, ingress, ingress-nginx, litellm-router, mission-control, models, monitoring, nutriguard, openclaw-operator, playground, registry, searxng, supabase, etc.)
- Many apps use GitOps/ArgoCD patterns: argocd-application.yaml, kustomization.yaml

## Litellm Deployment Status
- **Current**: No litellm deployments found in MicroK8s (checked via kubectl get deployments -A | grep -i litellm; pods -A | grep -i litellm)
- **Existing**: Litellm Ingress + Service present in namespace `openclaw`:
  - Ingress: `litellm` (class nginx, host litellm.deeps-home.duckdns.org, TLS via letsencrypt-production)
  - Service: `litellm` (ClusterIP 10.152.183.87:4000)
- **Router Skeleton**: Created in ~/k8s-stack/apps/litellm-router/ (Namespace, Deployment, Service) for GitOps via ArgoCD

## GitOps & ArgoCD Presence
- Files with argocd/gitops/flux/kustomize:
  - argocd-cm.yaml (ConfigMap)
  - workflows/kustomization.yaml
  - apps/*/argocd-application.yaml or argocd-app.yaml (e.g., a2a-server, ollama, metallb-system, _disabled-chromadb, apps-dify-deploy)
  - apps/*/kustomization.yaml (many apps)
  - base/argocd/ (namespace, cm, repo, applications/*)
  - clusters/deeps/flux-system/ (gotk-components.yaml, gotk-sync.yaml, kustomization.yaml)
- Indicates existing ArgoCD and Flux installations; cluster appears GitOps-ready.

## Kubectl Use (Verification Only)
- Per instruction: kubectl used solely for verification; no changes made via kubectl apply/edit/patch.
- Commands used: get nodes, get all -A, get deployments -A, get pods -A, get ingress -A, describe ingress, get service.

## Next Steps
1. Align litellm-router with existing openclaw litellm (ingress/service) or decide on separate deployment.
2. Validate ArgoCD sync: ensure apps/ litellm-router is recognized and applied.
3. Optionally expose litellm-router via Ingress (TLS) if distinct from openclaw/litellm.
4. Iterate via GitOps: commit → ArgoCD applies → verify.

---
*Always commit changes to ~/k8s-stack before expecting ArgoCD to sync to cluster.*