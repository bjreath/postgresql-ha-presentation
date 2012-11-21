mkdir ./pg_data
sudo chown postgres pg_data
sudo chgrp postgres pg_data
sudo -u postgres cp /var/lib/postgresql/9.1/main ./pg_data
sudo -u postgres rm -rf /var/lib/postgresql/9.1/main
sudo -u postgres mkdir /var/lib/postgresql/9.1/main
sudo -u postgres tar xzvf backup/base.tar.gz -C /var/lib/postgresql/9.1/main
sudo -u postgres rm -rf /var/lib/postgresql/9.1/main/pg_xlog
sudo -u postgres mkdir /var/lib/postgresql/9.1/main/pg_xlog
sudo -u postgres chmod -R 0700 /var/lib/postgresql/9.1/main
echo "standby_mode = 'on'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf
echo "primary_conninfo = 'host=192.168.1.11 port=5432 user=postgres password=postgres'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf
echo "trigger_file = '/tmp/postgresql.trigger.5432'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf
