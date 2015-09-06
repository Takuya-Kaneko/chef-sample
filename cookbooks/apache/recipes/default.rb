package ['httpd', 'httpd-devel', 'curl-devel', 'apr-devel', 'apr-util-devel'] do
  action :install
end

service 'httpd' do
  action [:enable, :start]
end