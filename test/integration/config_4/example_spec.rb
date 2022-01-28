describe package('haproxy') do
  it { should be_installed }
end

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }
  cfg_content = [
    'global',
    '  user haproxy',
    '  group haproxy',
    '  log /dev/log syslog info',
    '  log-tag haproxy',
    '  daemon',
    '  quiet',
    '  stats socket /var/run/haproxy.sock user haproxy group haproxy',
    '  stats timeout 2m',
    '  maxconn 4096',
    '  pidfile /var/run/haproxy.pid',
    '',
    '',
    'defaults',
    '  timeout client 10s',
    '  timeout server 10s',
    '  timeout connect 10s',
    '  log global',
    '  mode http',
    '  balance roundrobin',
    '  hash-type consistent',
    '  option httplog',
    '  option dontlognull',
    '  option redispatch',
    '  option tcplog',
    '',
    '',
    'backend servers',
    '  server disabled-server 127.0.0.1:1 disabled',
    '  hash-type consistent',
    '',
    '',
    'backend single-reqrep-reqirep',
    '  server disabled-server 127.0.0.1:1 disabled',
    '  reqrep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqirep \^Host:\\\ www.mydomain.com   Host:\\\ www',
    '',
    '',
    'backend multi-reqrep',
    '  server disabled-server 127.0.0.1:1 disabled',
    '  reqrep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqrep \^Host:\\\ www.mydomain.com   Host:\\\ www',
    '',
    '',
    'backend multi-reqirep',
    '  server disabled-server 127.0.0.1:1 disabled',
    '  reqirep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqirep \^Host:\\\ www.mydomain.com   Host:\\\ www',
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
    '  bind-process odd',
    '  hash-type consistent',
    '',
    '',
    'listen single-reqrep-reqirep',
    '  bind 0.0.0.0:8001',
    '  reqrep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqirep \^Host:\\\ www.mydomain.com   Host:\\\ www',
    '  default_backend servers',
    '',
    '',
    'listen multi-reqrep',
    '  bind 0.0.0.0:8002',
    '  reqrep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqrep \^Host:\\\ www.mydomain.com   Host:\\\ www',
    '  default_backend servers',
    '',
    '',
    'listen multi-reqirep',
    '  bind 0.0.0.0:8003',
    '  reqirep \^Host:\\\ ftp.mydomain.com   Host:\\\ ftp',
    '  reqirep \^Host:\\\ www.mydomain.com   Host:\\\ www',
    '  default_backend servers',
  ]
  its('content') { should match /#{cfg_content.join('\n')}/ }
end

describe service('haproxy') do
  it { should be_running }
end
