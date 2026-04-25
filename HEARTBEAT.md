# HEARTBEAT - Auto Task Detection & Repair

## Config
- Interval: 15-30 minuten
- Task file: /tmp/repair-tasks.json
- Report file: /tmp/task-report.txt

## Stap 1: Detecteer problemen
```bash
echo "=== HEARTBEAT SCAN ($(date) ===" > /tmp/task-report.txt

# ArgoCD problemen
argocd app list --grpc-web 2>/dev/null | grep -E "OutOfSync|Degraded|Progressing" | while read line; do
  app=$(echo "$line" | awk '{print $1}' | sed "s|argocd/||")
  echo "ARGOCD: $app ($(echo "$line" | awk '{print $2}')" >> /tmp/task-report.txt
done

# Pod problemen
kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded 2>/dev/null | grep -v "NAMESPACE" | while read ns pod status restarts age; do
  echo "POD: $ns/$pod ($status)" >> /tmp/task-report.txt
done
```

## Stap 2: Registreer in task file
```bash
jq --arg report "$(cat /tmp/task-report.txt)" \
  '.lastScan = $report | .tasks = (.tasks + [{"time":(now | todate), "report": $report}] | unique)' \
  /tmp/repair-tasks.json > /tmp/repair-tasks-tmp.json 2>/dev/null
mv /tmp/repair-tasks-tmp.json /tmp/repair-tasks.json 2>/dev/null || true
```

## Stap 3: Toon status
```bash
echo "=== HEARTBEAT STATUS ==="
echo "Tasks: $(jq -r ".tasks | length" /tmp/repair-tasks.json 2>/dev/null || echo 0)"
echo "Report:"
cat /tmp/task-report.txt 2>/dev/null | head -20
```

## Stap 4: Repareer eenvoudige problemen direct
```bash
# OutOfSync apps syncen
argocd app list --grpc-web 2>/dev/null | grep "OutOfSync" | awk '{print $1}' | sed "s|argocd/||" | while read app; do
  echo "Syncing $app..."
  kubectl apply -f ~/k8s-stack/apps/$app/ 2>/dev/null || true
done

# Pending pods verwijderen
kubectl get pods -A --field-selector=status.phase=Pending 2>/dev/null | grep -v "NAMESPACE" | awk '{print $1, $2}' | while read ns pod; do
  kubectl delete pod -n $ns $pod --force --grace-period=0 2>/dev/null || true
done
```

