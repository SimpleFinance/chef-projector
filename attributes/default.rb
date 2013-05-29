default['projector']['command'] = 'make'
default['projector']['target'] = 'build'
default['projector']['owner'] = node['jenkins']['XXX']['owner']
default['projector']['group'] = node['jenkins']['XXX']['group']
default['projector']['template'] = 'config.xml.erb'
default['projector']['branch'] = 'master'
default['projector']['databag'] = 'projector'
