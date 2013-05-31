default['projector']['databag'] = 'projector'

default['projector']['queue']['sqs_queue_name'] = 'projector'
default['projector']['queue']['aws_access_key'] = nil
default['projector']['queue']['aws_secret_key'] = nil

default['projector']['job']['command'] = 'make'
default['projector']['job']['target'] = 'build'
default['projector']['job']['owner'] = node['jenkins']['server']['user']
default['projector']['job']['group'] = node['jenkins']['server']['group']
default['projector']['job']['template'] = 'config.xml.erb'
default['projector']['job']['queue'] = node['projector']['queue']

default['projector']['repository']['branch'] = 'master'
default['projector']['repository']['org'] = nil
default['projector']['repository']['hooks'] = {}
default['projector']['repository']['connection'] = nil
default['projector']['repository']['queue'] = node['projector']['queue']
