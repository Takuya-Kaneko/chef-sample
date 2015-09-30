# sshdサービスの有効化
service "sshd" do
  supports :start => true, :status => true, :restart => true, :reload => true
  action [ :enable]
end

# sshd_configの配置
template "sshd_config" do
  path "/etc/ssh/sshd_config"
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :start, "service[sshd]"
end