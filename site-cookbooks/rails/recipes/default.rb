# Install rbenv & global & rehash
include_recipe 'rbenv::system'
rbenv_ruby node['rbenv']['version']
rbenv_global node['rbenv']['version']

execute "change rbenv permissions" do
  command "chown -R #{node['admin']['user']}:#{node['admin']['user']} #{node['rbenv']['path']}"
  user "root"
  action :run
end

bash "bundler" do
  user   node['admin']['user']
  cwd    "/home/#{node['admin']['user']}"
  code   "source rbenv.sh; gem install bundler"
  action :run
  not_if { ::File.exists? "#{node['rbenv']['path']}/shims/bundle" }
  notifies :run, "execute[change rbenv permissions]"
end

# Install apache and set configs
package ['httpd', 'httpd-devel', 'curl-devel', 'apr-devel', 'apr-util-devel'] do
  action :install
end

service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd_conf.erb"
  owner node['admin']['user']
  group node['admin']['user']
  mode 0600
end

execute "change httpd permissions" do
  command "chown -R #{node['admin']['user']}:#{node['admin']['user']} #{node['httpd']['path']}"
  user "root"
  action :run
end

# Install passenger & set configs
rbenv_gem 'passenger' do
  version node['passenger']['version']
  action :install
end

execute "change passenger permissions" do
  command "chown -R #{node['admin']['user']}:#{node['admin']['user']} #{node['rbenv']['path']}/versions/2.2.3/lib/ruby/gems/2.2.0/gems/passenger-#{node['passenger']['version']}"
  user "root"
  action :run
end

conf_path = '/etc/httpd/conf.d/passenger.conf'
unless File.exists?(conf_path)
  rbenv_script "passenger_module" do
    code <<-CODE
      passenger-install-apache2-module --auto
      passenger-install-apache2-module --snippet > /etc/httpd/conf.d/passenger.conf
    CODE
  end
end

template "passenger.conf" do
  path "/etc/httpd/conf.d/passenger.conf"
  source "passenger_conf.erb"
  notifies :reload, "service[httpd]"
end
