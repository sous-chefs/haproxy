property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, Hash, default: { '/dev/log' => 'syslog info' }
property :daemon, [TrueClass, FalseClass], default: true
property :debug_option, String, default: 'quiet', equal_to: %w(quiet debug)
property :enable_stats_socket, [TrueClass, FalseClass], default: true
property :stats, String, default: 'socket /var/run/haproxy.sock user haproxy group haproxy'
property :maxconn, Integer, default: 4096

property :client_timeout, String, default: '10s'
property :server_timeout, String, default: '10s'
property :connect_timeout, String, default: '10s'
property :config_cookbook, String, default: 'haproxy'
property :enable_default_http, [TrueClass, FalseClass], default: true
property :mode, String, default: 'http', equal_to: %w(http)
property :ssl_mode, String, default: 'http'
property :bind_address, String, default: '0.0.0.0'
property :bind_port, Integer, default: 80
