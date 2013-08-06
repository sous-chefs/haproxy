default['haproxy']['config']['global']['log'] = [ '127.0.0.1 local0',
                                                  '127.0.0.1 local1 notice' ]
default['haproxy']['config']['global']['maxconn'] = node['haproxy']['global_max_connections']
default['haproxy']['config']['global']['debug'] = false
default['haproxy']['config']['global']['quiet'] = false
default['haproxy']['config']['global']['user'] = node['haproxy']['user']
default['haproxy']['config']['global']['group'] = node['haproxy']['group']

default['haproxy']['config']['defaults']['log'] = 'global'
default['haproxy']['config']['defaults']['mode'] = 'http'
default['haproxy']['config']['defaults']['retries'] = 3
default['haproxy']['config']['defaults']['timeout connect'] = '5s'
default['haproxy']['config']['defaults']['timeout client'] = '50s'
default['haproxy']['config']['defaults']['timeout server'] = '50s'
default['haproxy']['config']['defaults']['option'] = [ 'httplog',
                                                       'dontlognull',
                                                       'redispatch' ]
default['haproxy']['config']['defaults']['balance'] = node['haproxy']['balance_algorithm']
