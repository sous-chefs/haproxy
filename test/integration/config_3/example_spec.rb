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

  its('content') { should match(/user haproxy/) }
  its('content') { should match(/group haproxy/) }
  its('content') { should match(/quiet/) }
  its('content') { should match(%r{log \/dev\/log syslog info}) }
  its('content') { should match(/listen http-in/) }
  its('content') { should match(/maxconn 4106/) }
  its('content') { should match(/bind 0.0.0.0:80/) }
end
