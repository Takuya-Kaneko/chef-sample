remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm" do
  source 'http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm'
  action :create
end

rpm_package "mysql-community-release" do
  source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm"
  action :install
end

package 'mysql-community-server' do
  action :install
end

service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

execute 'set root password' do
  command "mysqladmin -u root password '#{node['mysql']['server_root_password']}'"
  only_if "msyql -u root -e 'show databases;'"
end