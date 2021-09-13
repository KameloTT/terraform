sed 's/safe_to_bootstrap: 0/safe_to_bootstrap: 1/' -i /var/lib/mysql/grastate.dat
mysql --user=root --password=$MYSQL_ROOT_PASSWORD -Bse 'FLUSH TABLES WITH READ LOCK;system ${WAIT_CMD};'
