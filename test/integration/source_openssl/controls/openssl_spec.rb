# frozen_string_literal: true

describe file '/usr/bin/openssl' do
  it { should exist }
end

describe directory '/usr/local/openssl/bin/' do
  it { should exist }
end

describe command('haproxy -vv') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^Built with SSL library version : OpenSSL 3\.5\.5\b/) }
  its('stdout') { should match(/^Running on SSL library version : OpenSSL 3\.5\.5\b/) }
end
