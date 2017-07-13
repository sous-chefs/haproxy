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
  its('content') { should match(/maxconn 256/) }
  its('content') { should match(%r{stats socket /var/lib/haproxy/stats level admin}) }
  its('content') { should match(%r{stats uri /haproxy-status}) }
  its('content') { should match(/frontend http-in/) }
  its('content') { should include('redirect prefix http://www.bar.com code 301 if { hdr(host) -i foo.com }') }
  its('content') { should include('redirect prefix http://www.bar.com code 301 if { hdr(host) -i www.foo.com }') }
  its('content') { should match(/frontend multiport/) }
  its('content') { should match(/bind \*:80/) }
  its('content') { should match(/bind \*:8080/) }
  its('content') { should match(/bind 0.0.0.0:8081/) }
  its('content') { should match(/bind 0.0.0.0:8180/) }
  its('content') { should match(/^backend servers/) }
  its('content') { should match(/default_backend servers/) }
  its('content') { should match(/server server1 127.0.0.1:8000 maxconn 32/) }
  its('content') { should match(/frontend tcp-in\n  mode tcp/) }
  its('content') { should match(/backend tcp-servers\n  mode tcp/) }
end

describe service('haproxy') do
  it { should be_running }
end
