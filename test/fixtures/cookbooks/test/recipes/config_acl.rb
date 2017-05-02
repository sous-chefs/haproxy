# frozen_string_literal: true
haproxy_install 'package'

directory '/etc/haproxy/errors' do
  user 'haproxy'
  group 'haproxy'
end

file '/etc/haproxy/errors/403.http' do
  content '<h1>Error: 403</h1>'
end

haproxy_config_global 'global' do
  daemon false
  maxconn 4096
  chroot '/var/lib/haproxy'
  stats socket: '/var/lib/haproxy/haproxy.stat mode 600 level admin',
        timeout: '2m'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5s',
          client: '50s',
          server: '50s'
  log 'global'
  retries 3
end

haproxy_frontend 'http' do
  bind '0.0.0.0:80'
  default_backend 'rrhost'
  maxconn 2000
  use_backend ['abuser if source_is_abuser']
  option %w(httplog dontlognull forwardfor)
  acl ['kml_request path_reg -i /kml/',
       'bbox_request path_reg -i /bbox/',
       'source_is_abuser src_get_gpc0(http) gt 0',
  ]
  extra_options 'stick-table' => 'type ip size 200k expire 10m store gpc0',
                'tcp-request' => 'connection track-sc1 src if !source_is_abuser'
end

haproxy_acl 'gina_host hdr(host) -i foo.bar.com' do
  section 'frontend'
  section_name 'http'
end

haproxy_use_backend 'gina if gina_host' do
  section 'frontend'
  section_name 'http'
end

haproxy_acl 'acls for frontend:http' do
  section 'frontend'
  section_name 'http'
  acl [
    'rrhost_host hdr(host) -i dave.foo.bar.com foo.foo.com',
    'tile_host hdr(host) -i dough.foo.bar.com',
  ]
end

haproxy_use_backend 'use_backends for frontend:http' do
  section 'frontend'
  section_name 'http'
  use_backend [
    'rrhost if rrhost_host',
    'tiles_public if tile_host',
  ]
end

haproxy_backend 'tiles_public' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
  tcp_request ['content track-sc2 src',
               'content reject if conn_rate_abuse mark_as_abuser']
  acl ['conn_rate_abuse sc2_conn_rate gt 3000',
       'data_rate_abuse sc2_bytes_out_rate gt 20000000',
       'mark_as_abuser sc1_inc_gpc0 gt 0',
     ]
  extra_options(
    'stick-table' => 'type ip size 200k expire 2m store conn_rate(60s),bytes_out_rate(60s)',
    'http-request' => 'set-header X-Public-User yes'
  )
end

haproxy_backend 'abuser' do
  extra_options 'errorfile' => '403 /etc/haproxy/errors/403.http'
end

haproxy_backend 'rrhost' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
end

haproxy_backend 'gina' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  extra_options('block if restricted_page' => '!network_allowed')
end

haproxy_acl 'acls for listen' do
  section 'listen'
  section_name 'admin'
  acl ['network_allowed src 127.0.0.1']
end

haproxy_acl 'restricted_page path_beg /' do
  section 'listen'
  section_name 'admin'
end
