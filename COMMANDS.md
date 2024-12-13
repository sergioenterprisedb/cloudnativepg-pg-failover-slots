# Commands

```
k exec -it pg1-1 -- psql -d app -c "insert into test (description) values ('test')"
k exec -it pg1-1 -- psql -d app -c "insert into test (description) select description from test"
k exec -it pg1-1 -- psql -d app -c "delete from test"
k exec -it pg1-1 -- psql -d app -c "select count(*) from test"
k exec -it pg1-1 -- psql -d app -c "select * from test"

k exec -it pg2-1 -- psql -d app -c "select count(*) from test"
k exec -it pg2-1 -- psql -d app -c "select * from test"
```