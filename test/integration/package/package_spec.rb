# frozen_string_literal: true
describe package('haproxy') do
  it { should be_installed }
end

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file '/etc/haproxy/haproxy.cfg' do
  its(:mode) { should cmp '0644' }
end

if os.debian? && os.release.start_with?('14')
  describe service 'haproxy' do
    it { should be_installed }
    it { should be_running }
  end
else
  describe service 'haproxy' do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
