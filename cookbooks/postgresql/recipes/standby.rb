include_recipe "postgresql::client"

package "postgresql-9.1"

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/postgresql/9.1/main/pg_hba.conf" do
  source "pg_hba.standby.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

template "/etc/postgresql/9.1/main/postgresql.conf" do
  source "postgresql.standby.conf.erb"
  owner "postgres"
  group "postgres"
  backup false
  mode 0644
  notifies :restart, "service[postgresql]"
end

# template "/var/lib/postgresql/9.1/main/recovery.conf" do
#   source "recovery.conf.erb"
#   owner "postgres"
#   group "postgres"
#   backup false
#   mode 0644
#   notifies :restart, "service[postgresql]"
# end
