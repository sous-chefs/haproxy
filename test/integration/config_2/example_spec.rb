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
  its('content') { should match(/acl kml_request path_reg -i \/kml\//) }
  its('content') { should match(%r{/acl bbox_request path_reg	-i /bbox/}) }
  its('content') { should match(/acl gina_host hdr(host) -i foo.bar.com/) }
  its('content') { should match(/acl rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com/) }
  its('content') { should match(/acl rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com/) }
  its('content') { should match(%r{acl tile_host hdr(host) -i -f /etc/haproxy/tile_domains.lst}) }
  its('content') { should match(/tcp-request connection track-sc1 src if ! source_is_abuser/) }
  # Tiles Public
  its('content') { should match(/backend tiles_public/) }
  its('content') { should match /conn_rate_abuse sc2_conn_rate gt 3000/ }
  its('content') { should match /data_rate_abuse sc2_bytes_out_rate gt 20000000/ }
  its('content') { should match /reject if conn_rate_abuse !authorized_network mark_as_abuser/ }
  its('content') { should match /tile0 10.0.0.10:80 check weight 1 maxconn 100/ }
  its('content') { should match /tile1/ }
end
