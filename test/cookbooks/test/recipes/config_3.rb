apt_update

haproxy_install 'package'

haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log ['/dev/log local0', '/dev/log local1 notice']
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
  haproxy_retries 5
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  http_request [
    'add-header X-Forwarded-Proto https if { ssl_fc }',
    'add-header X-Proto http',
  ]
  http_response 'set-header Expires %[date(3600),http_date]'
  default_backend 'servers'
  option %w(dontlog-normal)
  extra_options('bind-process' => 'odd')
  hash_type 'consistent'
end

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

haproxy_frontend 'tcp-in' do
  mode 'tcp'
  bind '*:3307'
  default_backend 'tcp-servers'
end

haproxy_frontend 'multiport' do
  bind '*:8080' => '',
       '0.0.0.0:8081' => '',
       '0.0.0.0:8180' => ''
  default_backend 'servers'
end

haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end

haproxy_backend 'tcp-servers' do
  mode 'tcp'
  server ['server2 127.0.0.1:3306 maxconn 32']
end

haproxy_service 'haproxy' do
  action %i(create enable start)
end
