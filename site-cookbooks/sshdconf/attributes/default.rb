default['sshd']['Port'] = 22 # default: 22
default['sshd']['PermitRootLogin'] = 'no' # default: yes
default['sshd']['RSAAuthentication'] = 'yes'
default['sshd']['PubkeyAuthentication'] = 'yes'
default['sshd']['AuthorizedKeysFile'] = '.ssh/authorized_keys'
default['sshd']['PasswordAuthentication'] = 'no' # default: yes
default['sshd']['MaxStartups'] = '10:30:100'
