#!/bin/bash

# -----------------------------
# -- PLENARY_DOCUMENTS table --
# -----------------------------

table_plenary_documents="
CREATE TABLE plenary_documents (
            document_identifier TEXT PRIMARY KEY,
            document_title TEXT,
            document_type TEXT,
            document_parliamentary_term INTEGER,
            document_date DATE,
            document_public_register_notation TEXT,
            document_creator_person TEXT,
            document_creator_organization TEXT,
            document_language TEXT,
            document_pdf TEXT,
            document_doc TEXT,
            document_errata_pdf TEXT,
            document_errata_doc TEXT,
            document_amendments_pdf TEXT,
            document_amendments_doc TEXT,
            document_ep_number TEXT,
            document_number_version REAL,
            document_URI TEXT
          );
"
kubectl-cnpg psql pg1 << EOF
\c app
DROP TABLE IF EXISTS plenary_documents;

${table_plenary_documents}

ALTER TABLE plenary_documents OWNER TO app;

-- Drop publication and replication slot
DROP PUBLICATION IF EXISTS pub_plenary_documents;
SELECT pg_drop_replication_slot('plenary_documents');

CREATE PUBLICATION pub_plenary_documents FOR TABLE plenary_documents;
SELECT pg_create_logical_replication_slot('sub_slot_plenary_documents','pgoutput');
EOF

# pg2
kubectl-cnpg psql pg2 << EOF
\c app
DROP TABLE IF EXISTS test;

${table_plenary_documents}

ALTER TABLE plenary_documents OWNER TO app;

DROP SUBSCRIPTION sub_plenary_documents;
EOF

kubectl-cnpg subscription create pg2 \
             --publication pub_plenary_documents \
             --subscription sub_plenary_documents \
             --external-cluster pg1 \
             --publication-dbname app \
             --parameters "password_required=false,slot_name=sub_slot_plenary_documents,create_slot=false"

# ----------------
# -- TEST table --
# ----------------

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
