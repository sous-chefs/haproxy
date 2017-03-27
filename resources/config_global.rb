property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, Hash, default: { '/dev/log' => 'syslog info' }
property :daemon, [TrueClass, FalseClass], default: true
property :debug_option, String, default: 'quiet', equal_to: %w(quiet debug)
property :enable_stats_socket, [TrueClass, FalseClass], default: true
property :stats, String, default: 'socket /var/run/haproxy.sock user haproxy group haproxy'
property :maxconn, Integer, default: 4096
