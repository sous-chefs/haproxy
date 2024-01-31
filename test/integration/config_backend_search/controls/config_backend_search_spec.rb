title 'Frontend & Backend should be configurable'

include_controls 'haproxy-common'

describe package('haproxy') do
  it { should be_installed }
end

cfg_content = [
  'global',
  '  user haproxy',
  '  group haproxy',
  '  log /dev/log local0',
  '  log-tag WARDEN',
  '  chroot /var/lib/haproxy',
  '  daemon',
  '  quiet',
  '  stats socket /var/lib/haproxy/stats level admin',
  '  maxconn 256',
  '  pidfile /var/run/haproxy\.pid',
  '  tune\.bufsize 262144',
  '',
  '',
  'defaults',
  '  timeout connect 5000ms',
  '  timeout client 5000ms',
  '  timeout server 5000ms',
  '  log global',
  '  mode http',
  '  balance roundrobin',
  '  option httplog',
  '  option dontlognull',
  '  option redispatch',
  '  option tcplog',
  '',
  '',
  'frontend http-in',
  '  default_backend servers',
  '  bind \*:80',
  '',
  '',
  'backend servers',
  '  server disabled-server 127\.0\.0\.1:1 disabled',
  '  server be-1 10\.0\.0\.75:8000 maxconn 32',
  '  server be-2 10\.0\.0\.76:8000 maxconn 32',
]

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
