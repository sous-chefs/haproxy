# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
  extra_options 'tune.ssl.default-dh-param' => 2048
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
  haproxy_retries 5
end

directory '/etc/ssl/private' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/ssl/private/example.com.pem' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

haproxy_frontend 'http-in' do
  mode 'http'
  bind '*:80'
  extra_options redirect: 'scheme https code 301 if !{ ssl_fc }'
end

haproxy_frontend 'https' do
  mode 'http'
  bind '*:443 ssl crt /etc/ssl/private/example.com.pem'
  default_backend 'servers'
end

haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end
