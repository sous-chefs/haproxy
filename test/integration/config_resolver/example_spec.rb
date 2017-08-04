# frozen_string_literal: true

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }

  its('content') { should match(/^resolvers dns$/) }
  its('content') { should match(/^\s\snameserver google 8.8.8.8:53$/) }
  its('content') { should match(/^\s\sresolve_retries 30$/) }
  its('content') { should match(/^\s\stimeout retry 1s$/) }
end
