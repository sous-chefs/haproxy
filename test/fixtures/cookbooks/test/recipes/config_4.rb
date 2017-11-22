# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global '' do
end

haproxy_config_defaults '' do
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  http_request 'add-header X-Proto http'
  http_response 'set-header Expires %[date(3600),http_date]'
  default_backend 'servers'
  extra_options('bind-process' => 'odd')
end

haproxy_backend 'servers' do
  server ['disabled-server 127.0.0.1:1 disabled']
end
