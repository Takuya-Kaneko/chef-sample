user 'root' do
  password node['admin']['password']
  action :create
end

user_account node['admin']['user'] do
  password node['admin']['password']
  ssh_keys node['admin']['ssh_keys']
  action :create
end

