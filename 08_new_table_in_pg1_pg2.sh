#!/bin/bash

new_table="
CREATE TABLE test (
  id SERIAL PRIMARY KEY,
  description TEXT
);
"

# pg1
kubectl-cnpg psql pg1 << EOF
\c app
DROP TABLE IF EXISTS test;

${new_table}

ALTER TABLE test OWNER TO app;

INSERT INTO test (description) values ('aaa');
INSERT INTO test (description) values ('bbb');
INSERT INTO test (description) values ('ccc');

-- Drop publication and replication slot
DROP PUBLICATION IF EXISTS pub_test;
SELECT pg_drop_replication_slot('pub_test');

CREATE PUBLICATION pub_test FOR TABLE test;
SELECT pg_create_logical_replication_slot('sub_slot_test','pgoutput');

EOF
#kubectl-cnpg publication create pg1 \
#             --publication pub_test \
#             --table test \
#             --dbname app


# pg2
kubectl-cnpg psql pg2 << EOF
\c app
DROP TABLE IF EXISTS test;

${new_table}

ALTER TABLE test OWNER TO app;

DROP SUBSCRIPTION sub_test;

--CREATE SUBSCRIPTION sub_test 
--CONNECTION 'host=pg1-rw user=logical_repuser dbname=app sslmode=require password=Thisisatest01#' 
--PUBLICATION pub_test;

EOF

kubectl-cnpg subscription create pg2 \
             --publication pub_test \
             --subscription sub_test \
             --external-cluster pg1 \
             --publication-dbname app \
             --parameters "password_required=false,slot_name=sub_slot_test,create_slot=false"
