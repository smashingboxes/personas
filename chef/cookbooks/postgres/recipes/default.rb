#
# Cookbook Name:: postgres
# Recipe:: default
#

package "postgresql" do
  action :install
end

node.set_unless[:postgresql][:password][:postgres] = secure_password

bash "assign-postgres-password" do
  user 'postgres'
  code <<-EOH
echo "ALTER ROLE postgres ENCRYPTED PASSWORD '#{node[:postgresql][:password][:postgres]}';" | psql
  EOH
  action :run
end
