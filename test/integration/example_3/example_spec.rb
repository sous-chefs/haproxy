# See https://github.com/sous-chefs/haproxy/issues/151 for more information
global
     user haproxy
     group haproxy
     pidfile /var/run/haproxy.pid
     log /dev/log syslog info
     daemon
     quiet
     stats socket /var/run/haproxy.sock user haproxy group haproxy
     maxconn 4106
defaults
     timeout client 10s
     timeout server 10s
     timeout connect 10s

     log global
     mode http
     balance roundrobin
     option httplog
     option dontlognull
     option redispatch
     option httpchk GET /
     stats uri /haproxy-status
     http-check disable-on-404
     cookie SERVERID insert indirect nocache
frontend all_requests
     default_backend example
     bind 0.0.0.0:80
     maxconn 4096
     acl acl_test_example hdr_dom(host) -i -m dom test.example.com
     acl acl_appserver path_dom -i /appserver
     acl acl_example hdr_dom(host) -i -m dom example.com
     use_backend test_example if acl_test_example
     use_backend appserver if acl_appserver
     use_backend example if acl_example
     bind 0.0.0.0:445 ssl crt /usr/local/etc/haproxy/ssl_cert.pem no-sslv3
     redirect scheme https if !{ ssl_fc }
backend test_example
     server disabled-server 127.0.0.1:1 disabled
     server 01-ABCDEFGH0123 192.0.2.2:8080 inter 300 rise 3 fall 2 maxconn 100 check cookie 01-ABCDEFGH0123
backend appserver
     server disabled-server 127.0.0.1:1 disabled
     server 02-ABCDEFGH0123 192.0.2.2:8080 inter 300 rise 3 fall 2 maxconn 100 check cookie 02-ABCDEFGH0123
backend example
     server disabled-server 127.0.0.1:1 disabled
     server 03-ABCDEFGH0123 192.0.2.2:8080 inter 300 rise 3 fall 2 maxconn 100 check cookie 03-ABCDEFGH0123

describe package('haproxy') do
 it { should be_installed }
end

describe directory '/etc/haproxy' do
 it { should exist }
end

describe file('/etc/haproxy/haproxy.cfg') do
 it { should exist }
 it { should be_owned_by 'haproxy' }
 it { should be_grouped_into 'haproxy' }

#Global
user haproxy
group haproxy
pidfile /var/run/haproxy.pid
log /dev/log syslog info
daemon
quiet
stats socket /var/run/haproxy.sock user haproxy group haproxy
maxconn 4106

its('content') { should match(%r{user haproxy}) }
its('content') { should match(%r{group haproxy}) }

 its('content') { should match(%r{quiet}) }
 its('content') { should match(%r{log \/dev\/log syslog info}) }
 its('content') { should match(%r{listen http-in}) }
 its('content') { should match(%r{maxconn 32}) }
 its('content') { should match(%r{bind 0.0.0.0:80}) }
end
