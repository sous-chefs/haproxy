# frozen_string_literal: true
describe package('haproxy') do
  it { should be_installed }
end

describe directory '/etc/haproxy' do
  it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }
  its('content') { should_not match(/daemon/) }
  # Defaults
  its('content') { should match(/timeout client 50s/) }
  its('content') { should match(/timeout server 50s/) }
  its('content') { should match(/timeout connect 5s/) }
  its('content') { should match(/stick-table type ip size 200k expire 10m store gpc0/) }
  its('content') { should match(%r{acl kml_request path_reg -i /kml}) }
  its('content') { should match(%r{acl bbox_request path_reg -i /bbox}) }
  its('content') { should match(/acl gina_host hdr\(host\) -i foo.bar.com/) }
  its('content') { should match(/acl rrhost_host hdr\(host\) -i dave.foo.bar.com foo.foo.com/) }
  its('content') { should match(/tcp-request connection track-sc1 src if !source_is_abuser/) }
  # Tiles Public
  its('content') { should match(/backend tiles_public/) }
  its('content') { should match(/conn_rate_abuse sc2_conn_rate gt 3000/) }
  its('content') { should match(/data_rate_abuse sc2_bytes_out_rate gt 20000000/) }
  its('content') { should match(/reject if conn_rate_abuse mark_as_abuser/) }
  its('content') { should match(/tile0 10.0.0.10:80 check weight 1 maxconn 100/) }
  its('content') { should match(/tile1/) }

  its('content') { should match(/backend abuser/) }
  its('content') { should match(%r{errorfile 403 /etc/haproxy/errors/403.http}) }

  its('content') { should match(/listen admin/) }
  its('content') { should match(/bind 0.0.0.0:1337/) }
  its('content') { should match(/mode http/) }
  its('content') { should match(/acl network_allowed src 127.0.0.1/) }
  its('content') { should match(/acl restricted_page path_beg /) }
  its('content') { should match(/block if restricted_page !network_allowed/) }
  its('content') { should match(%r{stats uri /}) }
  its('content') { should match(/stats realm Haproxy-Statistics/) }
  its('content') { should match(/stats auth user:pwd/) }
end

describe service('haproxy') do
  it { should be_running }
end
