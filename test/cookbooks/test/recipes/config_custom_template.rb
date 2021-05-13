apt_update

haproxy_install 'package'

directory '/var/lib/haproxy' do
  owner 'haproxy'
  mode '0777'
end

haproxy_config_global '' do
  template 'custom-template.cfg.erb'
  cookbook 'test'
  chroot '/var/lib/haproxy'
  daemon true
  pidfile '/run/haproxy.pid'
end

haproxy_config_defaults '' do
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
end

haproxy_service 'haproxy' do
  action %i(create enable start)
end
