#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2012, CCI Systems, Inc.
#
# ALL RIGHTS RESERVED.
#

NGINX_PREFIX = "/usr/local/nginx"

case node.platform
when 'ubuntu', 'debian'
  package "nginx" do
    action :install
  end

  directory "/etc/nginx/certs" do
    owner "root"
    group "root"
    action :create
  end

  ["ccisystems.com.pem", "ccisystems.com.key"].each do |ssl_cert|
    cookbook_file "/etc/nginx/certs/#{ssl_cert}" do
      source "#{ssl_cert}"
      owner "root"
      group "root"
      mode 0600
      backup false
    end
  end

  file "/etc/nginx/sites-enabled/default" do
    action :delete
  end

  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
  end
end
