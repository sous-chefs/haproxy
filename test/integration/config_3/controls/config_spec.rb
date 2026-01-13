include_controls 'haproxy-common'

describe package('haproxy') do
  it { should be_installed }
end

cfg_content = [
  'global',
  '  user haproxy',
  '  group haproxy',
  '  log /dev/log local0',
  '  log /dev/log local1 notice',
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
  '  retries 5',
  '',
  '',
  'frontend http-in',
  '  default_backend servers',
  '  bind \*:80',
  '',
  '',
  'frontend tcp-in',
  '  mode tcp',
  '  default_backend tcp-servers',
  '  bind \*:3307',
  '',
  '',
  'frontend multiport',
  '  default_backend servers',
  '  bind \*:8080',
  '  bind 0\.0\.0\.0:8081',
  '  bind 0\.0\.0\.0:8180',
  '',
  '',
  'backend servers',
  '  server server1 127\.0\.0\.1:8000 maxconn 32',
  '',
  '',
  'backend tcp-servers',
  '  mode tcp',
  '  server server2 127\.0\.0\.1:3306 maxconn 32',
  '',
  '',
  'listen admin',
  '  mode http',
  '  bind 0.0.0.0:1337',
  '  stats uri /',
  '  stats realm Haproxy-Statistics',
  '  stats auth user:pwd',
  '  http-request add-header X-Forwarded-Proto https if { ssl_fc }',
  '  http-request add-header X-Proto http',
  '  http-response set-header Expires %\[date\(3600\),http_date\]',
  '  default_backend servers',
  '  option dontlog-normal',
]

platform_version = os.release.to_i
if platform_version < 10
  cfg_content << '  bind-process odd'
end
cfg_content << '  hash-type consistent'

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
