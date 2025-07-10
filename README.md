# Swarm Reconciler

Tiny watchdog for Docker Swarm.  
Every 60 s it scans for services stuck in **Pending** (`0/X` replicas) and
forces `docker service update --force`, kicking the scheduler back to life.

---

## Why?

Swarm pins tasks to the node that last satisfied a placement constraint.  
If that node dies and later rejoins, its tasks can sit in *Pending* forever.  
Reconciler nudges them so you don’t spend weekends redeploying stacks.

---

## Quick Start – one replica on **every manager**

```bash
# build once on any manager
docker build -t swarm-reconciler:latest .

# global service, managers only
docker service create --name swarm-reconciler \
  --mode global \
  --constraint 'node.role == manager' \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  swarm-reconciler:latest
```

Each manager now runs its own watchdog loop and heals stuck services automatically.



# tweak monitor.sh or Dockerfile
docker build -t swarm-reconciler:latest .
docker service update --force --image swarm-reconciler:latest swarm-reconciler
Customising
Interval – edit sleep 60 in monitor.sh.

Partial failures – adjust the awk/grep to include N/X.

Quiet mode – pipe docker service update … to /dev/null.

MIT License – hack away.
