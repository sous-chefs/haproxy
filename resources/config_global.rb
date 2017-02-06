property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, Hash, default: { '/dev/log' => 'syslog info' }
property :daemon, [TrueClass, FalseClass], default: true
property :quiet, [TrueClass, FalseClass], default: true
property :stats, String, default: 'socket /var/run/haproxy.sock user haproxy group haproxy'
property :maxconn, FixNum, default: 4096
