# frozen_string_literal: true

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }

  its('content') { should match(/^resolvers dns$/) }
  its('content') { should match(/^  nameserver google 8.8.8.8:53$/) }
  its('content') { should match(/^  resolve_retries 30$/) }
  its('content') { should match(/^  timeout retry 1s$/) }
end
