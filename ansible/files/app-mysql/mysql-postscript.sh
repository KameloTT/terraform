mysql --user=root --password=$MYSQL_ROOT_PASSWORD -Bse 'FLUSH LOGS; UNLOCK TABLES;'
sed 's/safe_to_bootstrap: 1/safe_to_bootstrap: 0/' -i /var/lib/mysql/grastate.dat
