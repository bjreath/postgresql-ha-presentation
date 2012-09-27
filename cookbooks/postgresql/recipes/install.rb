package "postgresql-9.1"

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/postgresql/9.1/main/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

template "/etc/postgresql/9.1/main/postgresql.conf" do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

# package "bison"
# package "flex"

# user "postgres" do
#   action :create
#   home "/home/postgres"
#   shell "/bin/bash"
# end

# directory("/home/postgres") do
#   owner "postgres"
#   mode "0755"
#   action :create
# end

# bash "install PostgreSQL from source" do
#   cwd "/usr/local/src"
#   user "root"
#   code <<-CMD
#     wget ftp://ftp.postgresql.org/pub/source/v9.1.1/postgresql-9.1.1.tar.gz && \
#     tar xzvf postgresql-9.1.1.tar.gz && \
#     cd postgresql-9.1.1 && \
#     ./configure && \
#     make && \
#     make install && \
#     cd contrib && \
#     make all && \
#     make install && \
#     rm -rf /usr/local/src/postgresql-9.1.1/ && \
#     rm /usr/local/src/postgresql-9.1.1.tar.gz
#   CMD
#   not_if "test -d /usr/local/pgsql"
# end

# execute "reload-ldconfig" do
#   command "ldconfig"
#   action :nothing
# end

# case node.platform
# when "centos"
#   template "/etc/ld.so.conf.d/postgresql.conf" do
#     source "postgresql.ldconfig.erb"
#     owner "root"
#     group "root"
#     mode 0755
#     backup false
#     notifies :run, "execute[reload-ldconfig]", :immediately
#   end
# end

# directory "/usr/local/pgsql/data" do
#   owner "postgres"
#   recursive true
#   action :create
# end

# bash "initialize PostgreSQL storage" do
#   cwd "/usr/local/pgsql"
#   user "postgres"
#   code <<-CMD
#     /usr/local/pgsql/bin/initdb -E utf8 --locale=en_US.UTF-8 -D /usr/local/pgsql/data
#   CMD
#   not_if "test -f /usr/local/pgsql/data/postgresql.conf"
# end

# template "/etc/init.d/postgresql" do
#   source "postgresql.init.erb"
#   owner "root"
#   group "root"
#   mode 0755
#   backup false
# end

# service "postgresql" do
#   supports :status => true, :restart => true, :reload => true
#   action [:enable, :start]
#   notifies :run, "bash[create-pgsql-user]"
# end

# bash "create-pgsql-user" do
#   cwd "/usr/local/pgsql"
#   user "postgres"
#   code "/usr/local/pgsql/bin/createuser --superuser ccisystems"
#   not_if "sudo -u postgres /usr/local/pgsql/bin/psql -c \"select * from pg_user\" | grep -c ccisystems"
#   action :nothing
# end

# monitor "postgresql" do
#   source "postgresql.god.erb"
# end
