require 'base64'
password = Base64.decode64 "cGFzc3dvcmQ=\n"

default['admin']['password'] = password
