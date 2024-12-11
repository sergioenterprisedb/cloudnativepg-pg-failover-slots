#!/bin/bash

. ./primary.sh

kubectl exec -it ${primary} -- psql app -c "\d"
kubectl exec -it ${primary} -- psql app -c "\dRp+"
kubectl exec -it ${primary} -- psql app -c "\du logical_repuser"
kubectl exec -it ${primary} -- psql app -c "select * from pg_replication_slots"
