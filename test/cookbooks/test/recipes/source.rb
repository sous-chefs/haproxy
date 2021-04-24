apt_update

haproxy_install 'source'

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_service 'haproxy' do
  action %i(create enable start)
end
