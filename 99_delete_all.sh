#!/bin/bash

kubectl delete cluster pg1
kubectl delete cluster pg2
kubectl delete secret logicalrepuser
sleep 2
kubectl delete pod pg1-1 --force
kubectl delete pod pg1-2 --force
kubectl delete pod pg1-3 --force

kubectl delete pod pg2-1 --force
kubectl delete pod pg2-2 --force
kubectl delete pod pg2-3 --force
