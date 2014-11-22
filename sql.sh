#!/bin/sh
USER="aaa"
PW="bbb"
DB="db_xxx_{{WORLDID}}"

STATEMENT="select * from table1;"


mysql -u$USER  -p$PW -D $DB -e "$STATEMENT"



