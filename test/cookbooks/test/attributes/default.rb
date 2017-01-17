default['haproxy']['enable_default_http'] = false
default['haproxy']['listeners']['listen']['lb_test'] = [
  'balance roundrobin',
  'bind 0.0.0.0:5000',
  'maxconn 10',
  'mode tcp',
  'server netcat1 127.0.0.1:5001',
  'server netcat2 127.0.0.1:5002',
]
