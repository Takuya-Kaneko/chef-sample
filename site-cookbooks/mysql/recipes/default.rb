remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm" do
  source 'http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm'
  action :create
end

package 'mysql-devel' do
  action :install
end

rpm_package "mysql-community-release" do
  source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm"
  action :install
end

package 'mysql-community-server' do
  version node['mysql-community-server']['version']
  action :install
end

service 'mysqld' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# secure install
root_password = node['mysql']['server_root_password']
execute "secure_install" do
  command "mysql -u root < #{Chef::Config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "mysql -u root -e 'show databases;'"
end

template "#{Chef::Config[:file_cache_path]}/secure_install.sql" do
  owner "root"
  group "root"
  mode 0644
  source "secure_install.sql.erb"
  variables({
    :root_password => root_password,
  })
  notifies :run, "execute[secure_install]", :immediately
end

# create database
db_name = node["mysql"]["db_name"]
execute "create_db" do
  command "mysql -u root -p#{root_password} < #{Chef::Config[:file_cache_path]}/create_db.sql"
  action :nothing
end

template "#{Chef::Config[:file_cache_path]}/create_db.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_db.sql.erb"
  variables({
    :db_name => db_name,
  })
  notifies :run, "execute[create_db]", :immediately
  not_if "mysql -u root -p#{root_password} -D #{db_name}"
end

# create user
user_name     = node["mysql"]["admin"]["user"]
user_password = node["mysql"]["admin"]["password"]
execute "create_user" do
  command "mysql -u root -p#{root_password} < #{Chef::Config[:file_cache_path]}/create_user.sql"
  action :nothing
  not_if "mysql -u #{user_name} -p#{user_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  notifies :run, "execute[create_user]", :immediately
end