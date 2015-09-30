template "/etc/sysconfig/iptables" do
  source "iptables.erb"
  owner "root"
  group "root"
  mode 0644
end

service "iptables" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end