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

  its('content') { should match(/listen admin/) }
  its('content') { should match(/bind 0.0.0.0:1337/) }
  its('content') { should match(/mode http/) }
  its('content') { should match(%r{stats uri /}) }
  its('content') { should match(/stats realm Haproxy-Statistics/) }
  its('content') { should match(/stats auth user:pwd/) }
  its('content') { should match(/http-request add-header X-Proto http/) }
  its('content') { should match(/http-response set-header Expires \%\[date\(3600\),http_date\]/) }
  its('content') { should match(/default_backend servers/) }
  its('content') { should match(/bind-process odd/) }
end

describe service('haproxy') do
  it { should be_running }
end
