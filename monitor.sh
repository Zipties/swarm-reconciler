#!/bin/bash
while true; do
  for svc in $(docker service ls --format '{{.Name}} {{.Replicas}}' | awk '$2 ~ /0\/[1-9]/ {print $1}'); do
    if docker service ps "$svc" --filter desired-state=running --format '{{.CurrentState}}' | grep -q '^Pending'; then
      echo "$(date '+%F %T') forcing update on: $svc (pending)"
      docker service update --force "$svc" >/dev/null 2>&1
    fi
  done
  sleep 60
done
