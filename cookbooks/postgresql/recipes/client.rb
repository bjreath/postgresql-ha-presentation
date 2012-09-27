case node.platform
when "ubuntu","debian"
  package "libpq-dev"
when "fedora","suse"
  package "postgresql-devel"
when "redhat","centos"
  package "postgresql-devel"
end
