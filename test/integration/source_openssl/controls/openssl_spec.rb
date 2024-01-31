include_controls 'haproxy-common'

describe file '/usr/bin/openssl' do
  it { should exist }
end

describe directory '/usr/local/openssl/bin/' do
  it { should exist }
end

describe command('haproxy -vv') do
  its('stdout') { should match(/OpenSSL version : OpenSSL 3.2.1/) }
end
