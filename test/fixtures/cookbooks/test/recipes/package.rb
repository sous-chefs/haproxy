# frozen_string_literal: true
apt_update

case node['platform_family']
when 'amazon', 'rhel'
  enable_uis = true
else
  enable_uis = false
end

haproxy_install 'package' do
  package_name enable_uis ? 'haproxy18u' : 'haproxy'
  enable_uis_repo true
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

haproxy_service 'haproxy'
