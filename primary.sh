#!/bin/bash

cluster_name="pg1"

export primary=`kubectl get pod -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.podIP}{'\t'}{.metadata.labels.role}{'\n'}" | grep ${cluster_name}- | grep primary | awk '{print $1}'`


words_count=$(echo $primary | wc -w)

# Check if the line count is more than 1
if [ "$words_count" -gt 1 ]; then
  echo "More than 1 word returned. Exiting."
  exit 1
fi

printf "Primary instance: ${primary}\n"

