apt_update

pkg_name = (platform_family?('rhel') && platform_version.to_i == 7) ? 'haproxy22' : 'haproxy'

haproxy_install 'package' do
  package_name pkg_name
  enable_ius_repo true
end

haproxy_config_global ''

haproxy_config_defaults ''

haproxy_frontend 'http-in' do
  default_backend 'servers'
end

haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
  notifies :restart, 'haproxy_service[haproxy]', :immediately
end

haproxy_service 'haproxy' do
  action %i(create enable start)
end
