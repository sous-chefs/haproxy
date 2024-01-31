include_controls 'haproxy-common'

describe package('haproxy') do
  it { should be_installed }
end

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should_not match(/^  daemon$/) }
  # Defaults
  defaults = [
    'defaults',
    '  timeout connect 5s',
    '  timeout client 50s',
    '  timeout server 50s',
    '  log global',
    '  mode http',
    '  balance roundrobin',
    '  option httplog',
    '  option dontlognull',
    '  option redispatch',
    '  option tcplog',
  ]
  its('content') { should match(/#{defaults.join('\n')}/) }
  # Frontend http
  frontend_http = [
    'frontend http',
    '  default_backend rrhost',
    '  bind 0.0.0.0:80',
    '  maxconn 2000',
    '  acl kml_request path_reg -i /kml/',
    '  acl bbox_request path_reg -i /bbox/',
    '  acl source_is_abuser src_get_gpc0\(http\) gt 0',
    '  acl gina_host hdr\(host\) -i foo.bar.com',
    '  acl rrhost_host hdr\(host\) -i dave.foo.bar.com foo.foo.com',
    '  acl tile_host hdr\(host\) -i dough.foo.bar.com',
    '  use_backend abuser if source_is_abuser',
    '  use_backend gina if gina_host',
    '  use_backend rrhost if rrhost_host',
    '  use_backend tiles_public if tile_host',
    '  option httplog',
    '  option dontlognull',
    '  option forwardfor',
    '  stick-table type ip size 200k expire 10m store gpc0',
    '  tcp-request connection track-sc1 src if !source_is_abuser',
  ]
  its('content') { should match(/#{frontend_http.join('\n')}/) }
  # Backend tiles_public
  tiles_public = [
    'backend tiles_public',
    '  server tile0 10.0.0.10:80 check weight 1 maxconn 100',
    '  server tile1 10.0.0.10:80 check weight 1 maxconn 100',
    '  acl conn_rate_abuse sc2_conn_rate gt 3000',
    '  acl data_rate_abuse sc2_bytes_out_rate gt 20000000',
    '  acl mark_as_abuser sc1_inc_gpc0 gt 0',
    '  tcp-request content track-sc2 src',
    '  tcp-request content reject if conn_rate_abuse mark_as_abuser',
    '  stick-table type ip size 200k expire 2m store conn_rate\(60s\),bytes_out_rate\(60s\)',
    '  http-request set-header X-Public-User yes',
  ]
  its('content') { should match(/#{tiles_public.join('\n')}/) }
  # Listen admin
  listen_admin = [
    'listen admin',
    '  mode http',
    '  bind 0.0.0.0:1337',
    '  stats uri /',
    '  stats realm Haproxy-Statistics',
    '  stats auth user:pwd',
    '  acl network_allowed src 127.0.0.1',
    '  acl restricted_page path_beg /',
    '  block if restricted_page !network_allowed',
  ]
  its('content') { should match(/#{listen_admin.join('\n')}/) }
end
