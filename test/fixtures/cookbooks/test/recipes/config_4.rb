# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global '' do
end

haproxy_config_defaults '' do
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats_uri '/'
  extra_options 'stats realm' => 'Haproxy-Statistics',
                'stats auth' => 'user:pwd'
end
