# frozen_string_literal: true
describe directory '/etc/haproxy' do
  it { should exist }
end

describe service 'haproxy' do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
