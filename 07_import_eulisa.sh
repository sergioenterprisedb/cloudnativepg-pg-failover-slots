#!/bin/bash
. ./primary.sh

#https://data.europarl.europa.eu/en/datasets/texts-tabled-for-the-plenary-of-the-european-parliament-year2024/38
kubectl exec -it ${primary} -- psql -d app -c "delete from plenary_documents"
kubectl exec -it ${primary} -- psql -d app < insert_eulisa.sql

