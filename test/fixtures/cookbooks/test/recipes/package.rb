# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_frontend 'http-in' do
  default_backend 'servers'
end

haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
  notifies :restart, 'haproxy_service[haproxy]', :immediately
end

haproxy_service 'haproxy'
