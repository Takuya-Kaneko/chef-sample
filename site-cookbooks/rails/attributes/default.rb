default['service']['name'] = 'chef_sample'
default['service']['directory'] = '/var/rails'
default['admin']['user'] = 'admin'

default['rbenv']['version'] = '2.2.3'
default['rbenv']['path'] = '/usr/local/rbenv'

default['httpd']['path'] = '/etc/httpd'
default['httpd']['ServerTokens'] = 'Prod'
default['httpd']['ServerSignature'] = 'Off'
default['httpd']['FollowSymLinks'] = 'Options -Indexes FollowSymLinks'

default['passenger']['version'] = '5.0.16'
default['passenger']['ServerName'] = 'default_server.com'
default['passenger']['RailsEnv'] = 'development'
default['passenger']['SECRET_KEY_BASE'] = nil

