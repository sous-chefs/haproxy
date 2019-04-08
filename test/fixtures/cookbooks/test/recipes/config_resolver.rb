# frozen_string_literal: true
apt_update

haproxy_install 'source'

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_resolver 'dns' do
  nameserver ['google 8.8.8.8:53']
  extra_options('resolve_retries' => 30,
                'timeout' => 'retry 1s')
  notifies :restart, 'haproxy_service[haproxy]', :delayed
end

haproxy_service 'haproxy'
