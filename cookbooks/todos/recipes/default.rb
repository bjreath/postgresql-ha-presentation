include_recipe "postgresql::client"

template "/etc/nginx/conf.d/todos.conf" do
  source "todos.nginx.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  notifies :restart, "service[nginx]"
end

current_path = "/vagrant/todos"

bash "bundle-dependencies" do
  cwd current_path
  user "vagrant"
  code "bundle install --deployment --without development test"
  not_if "test -d #{current_path}/vendor/bundle" # Not really good
end

bash "precompile-assets" do
  cwd current_path
  user "vagrant"
  code "bundle exec rake assets:precompile"
  not_if "test -d #{current_path}/public/assets" # Not really good
end

# bash "migrate-database" do
#   cwd current_path
#   user "vagrant"
#   code "RAILS_ENV=production bundle exec rake db:create db:migrate"
# end

monitor "todos" do
  source "todos.god.erb"
  environment node.chef_environment == "_default" ? 'production' : node.chef_environment
end
