# Swarm Reconciler

Tiny watchdog for Docker Swarm.  
Every 60 seconds it looks for services stuck in **Pending** (`0/X` replicas) and forces
`docker service update --force`, kicking the scheduler back to life.

## Why?
Swarm pins tasks to the last node that satisfied a constraint.  
If that node dies and later rejoins, the tasks stay in Pending forever.  
Reconciler nudges them so you don’t redeploy stacks manually.

## Quick start
```bash
docker build -t swarm-reconciler:latest .
docker service create --name swarm-reconciler \
  --constraint 'node.hostname == dock-servarr' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  swarm-reconciler:latest

