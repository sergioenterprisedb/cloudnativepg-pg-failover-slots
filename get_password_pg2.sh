#!/bin/bash
export PGPASSWORD=$(kubectl get secret --namespace default pg2-superuser -o jsonpath="{.data.password}" | base64 --decode)
echo $PGPASSWORD
