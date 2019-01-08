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
  listen_config = [
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
  ]
  its('content') { should match /#{listen_config.join('\n')}/ }
end

describe service('haproxy') do
  it { should be_running }
end
