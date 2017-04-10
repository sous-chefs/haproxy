haproxy 'package'

haproxy_config_global 'global' do
  daemon false
  maxconn 4096
  chroot '/var/lib/haproxy'
  stats_socket '/var/run/haproxy/haproxy.stat mode 600 level admin'
  stats_timeout 'timeout 2m'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5s',
          client: '50s',
          server: '50s'
  log 'global'
  retries 3
  extra_options 'stick-table' => 'type ip size 200k expire 10m store gpc0'
end

haproxy_frontend 'http' do
  bind '0.0.0.0:80'
  default_backend 'rrhost'
  maxconn 2000
  use_backend ['gina if gina_host','rrhost if rrhost_host',
               'abuser if source_is_abuser',
               'abuser if bad_client',
               'tiles if tile_host authorized_token',
               'tiles	if tile_host authorized_network',
               'tiles_kml if tile_host kml_request',
               'tiles_kml if tile_host bbox_request',
               'tiles_public if tile_host']
  option ['httplog','dontlognull','forwardfor']
  extra_options 'stick-table' => 'type ip size 200k expire 10m store gpc0',
                'tcp-request' => 'connection track-sc1 src if ! source_is_abuser'
end

haproxy_backend 'tiles_public' do
  server ['tile0 10.0.0.10:80 check weight 1 maxconn 100',
          'tile1 10.0.0.10:80 check weight 1 maxconn 100']
  extra_options 'tcp-request' => 'track-sc2 src',
                'tcp-request' => 'reject if conn_rate_abuse !authorized_network mark_as_abuser'
  # acl ['authorized_network	src	-f /etc/haproxy/authorized_networks.lst',
  #      'conn_rate_abuse  sc2_conn_rate gt 3000',
  #      'data_rate_abuse  sc2_bytes_out_rate  gt 20000000',
  #      'mark_as_abuser   sc1_inc_gpc0 gt 0'
  #    ]

end
