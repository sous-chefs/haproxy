require 'spec_helper'

describe file('/usr/local/etc/haproxy/haproxy.cfg') do
  it { is_expected.to exist }
  it { is_expected.to be_file }
  its(:content) { is_expected.to match('log 127.0.0.1 local0') }
  its(:content) { is_expected.to match('log 127.0.0.1 local1 notice') }
end
