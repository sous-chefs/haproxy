property :timeout, Hash, default: { client: '10s', server: '10s', connect: '10s' }
property :log, String, default: 'global'
property :mode, String, default: 'http'
property :balance, default: 'roundrobin', equal_to: %w(roundrobin static-rr leastconn first source uri url_param header rdp-cookie)
property :option, Array, default: %w(httplog dontlognull redispatch)
property :status_uri, String, default: '/haproxy-status'
property :status_user, String, default: 'stats'
property :status_password, String, default: 'stats'
