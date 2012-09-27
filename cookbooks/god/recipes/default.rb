#
# Cookbook Name:: god
# Recipe:: default
#
# Copyright 2011, CCI Systems, Inc.
#
# All rights reserved - Do Not Redistribute
#

local_username = data_bag_item('servers', 'security')['user']
local_group = data_bag_item('servers', 'security')['group']

if node['ruby'] && node['ruby']['version']
  ruby_version = node['ruby']['version']
elsif data_bag_item('servers', 'ruby')['version']
  ruby_version ||= data_bag_item('servers', 'ruby')['version']
else
  ruby_version ||= "1.9.3-p194"
end

gem_package("god") do
  action :install
  gem_binary '/usr/local/bin/gem'
end

link "/usr/local/bin/god" do
  to "/usr/local/ruby-#{ruby_version}/bin/god"
end

directory("/etc/god/conf.d") do
  recursive true
  owner local_username
  group local_group
  mode 0755
end

template("/etc/god/god.conf") do
  source "god.conf.erb"
  owner local_username
  group local_group
  mode 0755
  backup false
end

template("/etc/init.d/god") do
  source "god.init.erb"
  owner "root"
  group "root"
  mode 0755
  backup false
end

cookbook_file "/etc/god/conf.d/restart_file_touched.god"

service("god") do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
