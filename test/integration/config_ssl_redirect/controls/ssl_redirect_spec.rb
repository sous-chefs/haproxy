title 'Frontend & Backend should be configurable'

include_controls 'haproxy-common'

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
  '  tune\.ssl\.default-dh-param 2048',
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
  '  retries 5',
  '',
  '',
  'frontend http-in',
  '  mode http',
  '  bind \*:80',
  '  redirect scheme https code 301 if !\{ ssl_fc \}',
  '',
  '',
  'frontend https',
  '  mode http',
  '  default_backend servers',
  '  bind \*:443 ssl crt /etc/ssl/private/example\.com\.pem',
  '',
  '',
  'backend servers',
  '  server server1 127\.0\.0\.1:8000 maxconn 32',
]

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
