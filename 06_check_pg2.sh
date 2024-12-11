#!/bin/bash

kubectl exec -it pg2-1 -- psql app -c "\d"
kubectl exec -it pg2-1 -- psql app -c "select oid, subname, subsynccommit from pg_subscription"
kubectl exec -it pg2-1 -- psql app -c "\du logical_repuser"
