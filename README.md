# How to exec chef?

Environment: vagrant

```
chef exec knife zero bootstrap 192.168.33.10 -x vagrant -i #{vagrant_directory}/.vagrant/machines/#{vagrant_app_name}/virtualbox/private_key --sudo -r 'role[vagrant]'
```

# What would be installed?
 - git
 - mysql
 - apache
 - passenger
 - rbenv
