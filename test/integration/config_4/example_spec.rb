# frozen_string_literal: true
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
    '  stats uri /haproxy-status',
    '',
    '',
    'backend servers',
    '  server disabled-server 127.0.0.1:1 disabled',
    '  hash-type consistent',
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
    '  bind-process odd',
    '  hash-type consistent',
  ]
  its('content') { should match /#{cfg_content.join('\n')}/ }
end

describe service('haproxy') do
  it { should be_running }
end
