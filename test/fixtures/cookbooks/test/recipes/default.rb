apt_update 'update'

if platform_family?('rhel', 'fedora')
  package 'nc'
else
  package 'netcat'
end

include_recipe 'haproxy::manual'

node.default['haproxy']['enable_default_http'] = false
node. default['haproxy']['listeners']['listen']['lb_test'] = [
  'balance roundrobin',
  'bind 0.0.0.0:5000',
  'maxconn 10',
  'mode tcp',
  'server netcat1 127.0.0.1:5001',
  'server netcat2 127.0.0.1:5002',
]
