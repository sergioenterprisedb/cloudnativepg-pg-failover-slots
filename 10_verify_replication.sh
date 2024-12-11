#!/bin/bash

kubectl-cnpg psql pg1 << EOF
\c app
select slot_name, confirmed_flush_lsn from pg_replication_slots ;

SELECT slot_name, confirmed_flush_lsn, pg_current_wal_lsn(), 
  (pg_current_wal_lsn() - confirmed_flush_lsn) AS lsn_distance
FROM pg_replication_slots;
EOF

kubectl-cnpg psql pg2 << EOF
\c app
SELECT subname, received_lsn FROM pg_stat_subscription;
EOF
