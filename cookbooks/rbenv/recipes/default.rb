git "#{node['directory']['home']}/.rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision   "master"
  user       node['rbenv']['user']
  group      node['rbenv']['group']
  action     :sync
end

directory "#{node['directory']['home']}/.rbenv/plugins" do
  owner node['rbenv']['user']
  group node['rbenv']['group']
  # recursive true
  action :create
end

git "#{node['directory']['home']}/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision   "master"
  user       node['rbenv']['user']
  group      node['rbenv']['group']
  action     :sync
end

%w{.bash_profile .bashrc}.each do |filename|
  template filename do
    owner  node['rbenv']['user']
    group  node['rbenv']['group']
    mode   "0644"
    path   "#{node['directory']['home']}/#{filename}"
    source "#{filename}.erb"
  end
end

template "rbenv.sh" do
  owner  node['rbenv']['user']
  group  node['rbenv']['group']
  path   "#{node['directory']['home']}/rbenv.sh"
  source "rbenv.sh.erb"
end

package ["openssl-devel", "gcc", "readline-devel"] do
  action :install
end

bash "rbenv install #{node['rbenv']['versions']}" do
  user   node['rbenv']['user']
  cwd    node['directory']['home']
  code   "source rbenv.sh; rbenv install #{node['rbenv']['versions']}"
  action :run
  not_if { ::File.exists? "#{node['directory']['home']}/.rbenv/versions/#{node['rbenv']['versions']}" }
end

bash "rbenv rehash" do
  user   node['rbenv']['user']
  cwd    node['directory']['home']
  code   "source rbenv.sh; rbenv rehash"
  action :run
end

bash "rbenv global #{node['rbenv']['versions']}" do
  user   node['rbenv']['user']
  cwd    node['directory']['home']
  code   "source rbenv.sh; rbenv global #{node['rbenv']['versions']}"
  action :run
end

bash "bundler" do
  user   node['rbenv']['user']
  cwd    node['directory']['home']
  code   "source rbenv.sh; gem install bundler"
  action :run
  not_if { ::File.exists? "#{node['directory']['home']}/.rbenv/shims/bundle" }
end