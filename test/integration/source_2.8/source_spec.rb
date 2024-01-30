describe directory '/etc/haproxy' do
  it { should exist }
end

describe file '/etc/haproxy/haproxy.cfg' do
  its(:mode) { should cmp '0640' }
end

describe service 'haproxy' do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
