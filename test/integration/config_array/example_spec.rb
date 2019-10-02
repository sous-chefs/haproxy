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
  '',
  '',
  'frontend http-in',
  '  default_backend servers',
  '  bind \*:80',
  '  redirect prefix http://www\.bar\.com code 301 if \{ hdr\(host\) -i foo\.com \}',
  '  redirect prefix http://www\.bar\.com code 301 if \{ hdr\(host\) -i www\.foo\.com \}',
  '',
  'frontend tcp-in',
  '  mode tcp',
  '  default_backend tcp-servers',
  '  bind \*:3307',
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
  'backend tcp-servers',
  '  mode tcp',
  '  server server2 127\.0\.0\.1:3306 maxconn 32',
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
