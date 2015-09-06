user 'root' do
  username 'root'
  password node['admin']['password']
  action :create
end

user 'admin' do
  username 'admin'
  password node['admin']['password']
  action :create
end
