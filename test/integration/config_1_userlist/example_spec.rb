# frozen_string_literal: true
title 'Frontend & Backend should be configurable'

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
  its('content') { should match(/daemon/) }
  its('content') { should match(/timeout connect 5000ms/) }
  its('content') { should match(/frontend http-in/) }
  its('content') { should match(/bind \*:80/) }
  its('content') { should match(/backend servers/) }
  its('content') { should match(/server server1 127.0.0.1:8000 maxconn 32/) }
  its('content') { should match(/userlist mylist/) }
  its('content') { should match(/  group G1 users tiger,scott/) }
  its('content') { should match(/  group G2 users xdb,scott/) }
  its('content') { should include '$6$k6y3o.eP$JlKBx9za9667qe4(...)xHSwRv6J.C0/D7cV91' }
  its('content') { should match(/  user scott insecure-password elgato/) }
  its('content') { should match(/  user xdb insecure-password hello/) }
end

describe service('haproxy') do
  it { should be_running }
end
