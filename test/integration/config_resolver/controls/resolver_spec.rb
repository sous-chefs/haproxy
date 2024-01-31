include_controls 'haproxy-common'

cfg_content = [
  'global',
  '  user haproxy',
  '  group haproxy',
  '  log /dev/log syslog info',
  '  log-tag haproxy',
  '  daemon',
  '  quiet',
  '  stats socket /var/run/haproxy\.sock user haproxy group haproxy',
  '  stats timeout 2m',
  '  maxconn 4096',
  '  pidfile /var/run/haproxy\.pid',
  '',
  '',
  'resolvers dns',
  '  nameserver google 8\.8\.8\.8:53',
  '  resolve_retries 30',
  '  timeout retry 1s',
  '',
  '',
  'defaults',
  '  timeout client 10s',
  '  timeout server 10s',
  '  timeout connect 10s',
  '  log global',
  '  mode http',
  '  balance roundrobin',
  '  option httplog',
  '  option dontlognull',
  '  option redispatch',
  '  option tcplog',
]

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
