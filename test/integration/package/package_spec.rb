# frozen_string_literal: true
describe package('haproxy') do
  it { should be_installed }
end

describe directory '/etc/haproxy' do
  it { should exist }
end

describe service 'haproxy' do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
