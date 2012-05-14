#
# Cookbook Name:: postgres
# Recipe:: default
#

package "postgresql" do
  action :install
end

node.set_unless[:postgres_password] = "secret"

bash "assign-postgres-password" do
  user 'postgres'
  code <<-EOH
echo "ALTER ROLE postgres ENCRYPTED PASSWORD '#{node[:postgres_password]}';" | psql
  EOH
  action :run
end

bash "create-db" do
  user 'postgres'
  code "createdb #{node[:id]}"
  not_if { "psql --list | grep personas" }
  action :run
end
