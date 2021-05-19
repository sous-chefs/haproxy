describe file '/usr/bin/openssl' do
  it { should exist }
end

describe directory '/usr/local/openssl/bin/' do
  it { should exist }
end

describe command('haproxy -vv | grep "OpenSSL 1.1.1h"') do
  its('stdout') { should match /Running on OpenSSL version : OpenSSL 1.1.1h  22 Sep 2020/ }
end
