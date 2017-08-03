# frozen_string_literal: true

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }

  its('content') { should match(/^global/) }
  its('content') { should_not match(/^peers/) }
  its('content') { should_not match(/^mailers/) }
  its('content') { should_not match(/^listen/) }
  its('content') { should_not match(/^frontend/) }
  its('content') { should_not match(/^backend/) }
  its('content') { should_not match(/bind/) }
end

describe service('haproxy') do
  it { should be_running }
end
