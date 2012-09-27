if node['ruby'] && node['ruby']['version']
  ruby_version = node['ruby']['version']
elsif data_bag_item('servers', 'ruby')['version']
  ruby_version ||= data_bag_item('servers', 'ruby')['version']
else
  ruby_version ||= "1.9.3-p194"
end

PACKAGES = [
  'build-essential', 'zlib1g', 'zlib1g-dev', 'libreadline6', 'libreadline6-dev',
  'libssl-dev', 'curl', 'wget', 'ssl-cert', 'rsync', 'git-core'
]

PACKAGES.each do |pkg|
  package(pkg) do
    action :install
  end
end

bash "install Ruby with ruby-build" do
  cwd "/usr/local/src"
  user "root"
  code <<-CMD
    git clone git://github.com/sstephenson/ruby-build.git && \
    cd ./ruby-build && \
    sudo ./install.sh && \
    cd .. && \
    rm -rf ./ruby-build && \
    sudo ruby-build #{ruby_version} /usr/local/ruby-#{ruby_version} && \
    sudo ln -s /usr/local/ruby-#{ruby_version}/bin/ruby /usr/local/bin/ruby && \
    sudo ln -s /usr/local/ruby-#{ruby_version}/bin/gem /usr/local/bin/gem && \
    sudo ln -s /usr/local/ruby-#{ruby_version}/bin/rake /usr/local/bin/rake
  CMD
  not_if "test -f /usr/local/ruby-#{ruby_version}/bin/ruby"
end

gem_package("bundler") do
  gem_binary "/usr/local/bin/gem"
  version "1.2.0"
end

link "/usr/local/bin/bundle" do
  to "/usr/local/ruby-#{ruby_version}/bin/bundle"
end
