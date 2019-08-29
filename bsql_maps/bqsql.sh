#!/bin/sh
# sh bqsql.sh > bqsql.sql

n=0
for SQLFILE in */*sql
do
    NAME=$(basename "$SQLFILE" .sql)
    SQL=$(cat "$SQLFILE")
    if [ "$n" != "0" ]
    then
        echo "UNION ALL"
    fi
    echo "SELECT *,'$NAME' AS name FROM ($SQL)"
    n=$((n+1))
done
echo ";"
