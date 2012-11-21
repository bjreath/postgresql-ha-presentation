* Install master and slave servers
* Enable WAL archiving on the master server

* Stop PostgreSQL on master and slaves

* Take a base backup of the master server from the slave

    /usr/lib/postgresql/9.1/bin/pg_basebackup -D ./backup -F tar -z -U postgres -h 192.168.1.11
    chmod -R 777 backup/base.tar.gz
    sudo chown -R postgres backup

* Stop PostgreSQL on the slave

    sudo service postgresql stop

* Restore the slave server from the master backup

    mkdir ./pg_data
    sudo chown postgres pg_data
    sudo chgrp postgres pg_data
    sudo -u postgres cp -R /var/lib/postgresql/9.1/main ./pg_data
    sudo -u postgres rm -rf /var/lib/postgresql/9.1/main
    sudo -u postgres mkdir /var/lib/postgresql/9.1/main
    sudo -u postgres tar xzvf backup/base.tar.gz -C /var/lib/postgresql/9.1/main
    sudo -u postgres rm -rf /var/lib/postgresql/9.1/main/pg_xlog
    sudo -u postgres mkdir /var/lib/postgresql/9.1/main/pg_xlog
    sudo -u postgres chmod -R 0700 /var/lib/postgresql/9.1/main
    sudo -u postgres cp ./pg_data/main/server.crt /var/lib/postgresql/9.1/main/server.crt
    sudo -u postgres cp ./pg_data/main/server.key /var/lib/postgresql/9.1/main/server.key

    echo "standby_mode = 'on'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf
    echo "primary_conninfo = 'host=192.168.1.11 port=5432 user=postgres password=postgres'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf
    echo "trigger_file = '/tmp/postgresql.trigger.5432'" | sudo -u postgres tee -a /var/lib/postgresql/9.1/main/recovery.conf




* Unused commands

    sudo -u postgres cp -R ./pg_data/main/pg_xlog/ /var/lib/postgresql/9.1/main/pg_xlog

