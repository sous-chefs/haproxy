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

default['haproxy']['config']['frontend'] = {
  http: {
    maxconn: node['haproxy']['frontend_max_connections'],
    bind: "#{node['haproxy']['incoming_address']}:#{node['haproxy']['incoming_port']}",
    default_backend: 'servers_http' }}

if node['haproxy']['enable_ssl']
  default['haproxy']['config']['frontend'].merge!( https: {
                                                     maxconn: node['haproxy']['frontend_ssl_max_connections'],
                                                     mode: 'tcp',
                                                     bind: "#{node['haproxy']['ssl_incoming_address']}:#{node['haproxy']['ssl_incoming_port']}"},
                                                   default_backend: 'servers_https' )
end

default['haproxy']['config']['backend'] = {
  servers_http: {
    server: [ "localhost 127.0.0.1:4000 weight 1 maxconn #{node['haproxy']['member_max_connections']} check",
              "localhost 127.0.0.1:4001 weight 1 maxconn #{node['haproxy']['member_max_connections']} check" ]}}

if node['haproxy']['enable_ssl']
  default['haproxy']['config']['backend'].merge!( servers_https: {
                                                    mode: 'tcp',
                                                    option: ( if node['haproxy']['ssl_httpchk']
                                                                ['ssl-hello-chk', "httpchk #{node['haproxy']['ssl_httpchk']}"]
                                                              else
                                                                ['ssl-hello-chk']
                                                              end ),
                                                    server: [ "localhost 127.0.0.1:4000 weight 1 maxconn #{node['haproxy']['member_max_connections']} check",
                                                              "localhost 127.0.0.1:4001 weight 1 maxconn #{node['haproxy']['member_max_connections']} check" ]})
end

if node['haproxy']['enable_admin']
  default['haproxy']['config']['listen'] = {
    admin: {
      mode: 'http',
      stats: 'uri /' }}
end
