require 'base64'
password = Base64.decode64 "cGFzc3dvcmQ=\n"

default['mysql']['server_root_password'] = password

default['directory']['home'] = '/home/vagrant'