# Description
In this demo i'll show you how to replicate 2 tables using logical replication
from pg1 cluster to pg2 cluster.
I'm using pg_failover_slots extension to avoid to lose the replication slot when
switchover of failover occurs.

# Prerequisites
- K8s environment (k3d)
- I've created 6 nodes (3 nodes labeled dc1 and 3 nodes labeled dc2)

# Demo
Execute commands in the correct order.

# Remove all (clusters and secrets)
```
./99_remove_all.sh
```

