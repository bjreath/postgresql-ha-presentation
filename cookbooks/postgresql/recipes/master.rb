include_recipe "postgresql::client"

directory '/data/postgresql/archive' do
  owner 'postgres'
  group 'postgres'
  recursive true
end

package "postgresql-9.1"

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/postgresql/9.1/main/pg_hba.conf" do
  source "pg_hba.master.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

template "/etc/postgresql/9.1/main/postgresql.conf" do
  source "postgresql.master.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

bash "create-replication-user" do
  command "sudo -u postgres createuser --superuser vagrant"
  not_if "sudo -u postgres psql -c 'select usename from pg_user' | grep vagrant"
end
