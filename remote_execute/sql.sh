#!/bin/sh
USER="aaa"
PW="bbb"
DB="db_xxx"

STATEMENT="select * from table1;"


mysql -u$USER  -p$PW -D $DB -e "$STATEMENT"



