# frozen_string_literal: true
title 'Frontend & Backend should be configurable'

describe package('haproxy') do
  it { should be_installed }
end

describe directory '/etc/haproxy' do
  it { should exist }
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
  '  retries 5',
  '  stats uri /haproxy-status',
  '',
  '',
  'userlist mylist',
  '  group G1 users tiger,scott',
  '  group G2 users xdb,scott',
  '  user tiger password \$6\$k6y3o\.eP\$JlKBx9za9667qe4\(\.\.\.\)xHSwRv6J\.C0/D7cV91',
  '  user scott insecure-password elgato',
  '  user xdb insecure-password hello',
  '',
  '',
  'frontend http-in',
  '  default_backend servers',
  '  bind \*:80',
  '',
  '',
  'backend servers',
  '  server server1 127\.0\.0\.1:8000 maxconn 32',
]

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end

describe service('haproxy') do
  it { should be_running }
end
