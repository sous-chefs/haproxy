# frozen_string_literal: true
title ''

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
  its('content') { should match(%r{log \/dev\/log local0}) }
  its('content') { should match(%r{log \/dev\/log local1 notice}) }
  its('content') { should match(/frontend http-in/) }
  its('content') { should match(/maxconn 256/) }
  its('content') { should match(/bind \*:80/) }
end
