/usr/lib/postgresql/9.1/bin/pg_basebackup -D ./backup -F tar -z -U postgres -h 192.168.1.11 -U postgres
chmod -R 777 backup/base.tar.gz
sudo chown -R postgres backup
