# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global ''

haproxy_config_defaults '' do
  hash_type 'consistent'
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
  extra_options('bind-process' => 'odd')
  hash_type 'consistent'
end

haproxy_backend 'servers' do
  server ['disabled-server 127.0.0.1:1 disabled']
  hash_type 'consistent'
end

haproxy_service 'haproxy'
