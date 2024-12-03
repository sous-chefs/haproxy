# Test recipe for security configuration
haproxy_install 'package'

# Configure global settings
haproxy_config_global 'global' do
  user 'haproxy'
  group 'haproxy'
  log '/dev/log syslog info'
  log_tag 'haproxy'
  daemon true
  quiet true
  stats_socket '/var/run/haproxy.sock user haproxy group haproxy'
  stats_timeout '2m'
  maxconn 1000
  pidfile '/var/run/haproxy.pid'
end

# Configure defaults
haproxy_config_defaults 'defaults' do
  timeout_client '10s'
  timeout_server '10s'
  timeout_connect '10s'
  log 'global'
  mode 'http'
  balance 'roundrobin'
  option %w(httplog dontlognull redispatch tcplog)
end

# Configure frontend
haproxy_frontend 'http-in' do
  bind '0.0.0.0:80'
  default_backend 'servers'
end

# Configure backend
haproxy_backend 'servers' do
  server ['server1 127.0.0.1:8000 maxconn 32']
end

# Ensure config file permissions
file '/etc/haproxy/haproxy.cfg' do
  owner 'haproxy'
  group 'haproxy'
  mode '0640'
end
