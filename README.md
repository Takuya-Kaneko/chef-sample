# How to exec chef?

Environment: vagrant

```
chef exec knife zero bootstrap 192.168.33.10 -x vagrant -i #{vagrant_directory}/.vagrant/machines/alice/virtualbox/private_key --sudo -r 'role[chef-sample]'
```

# What would be installed?
 - git
 - mysql
 - apache
 - passenger
 - rbenv
