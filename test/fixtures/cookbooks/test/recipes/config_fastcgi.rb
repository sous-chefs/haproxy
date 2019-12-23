# frozen_string_literal: true
apt_update

haproxy_install 'source'

haproxy_fastcgi 'php-fpm' do
  log_stderr 'global'
  docroot '/var/www/my-app'
  index 'index.php'
  option ['keep-conn']
  extra_options('path-info' => '^(/.+\.php)(/.*)?$')
end

haproxy_frontend 'front-http' do
  bind('*:80' => '')
  mode 'http'
  use_backend ['back-dynamic if { path_reg ^/.+\.php(/.*)?$ }']
  default_backend 'back-static'
end

haproxy_backend 'back-static' do
  mode 'http'
  server ['www 127.0.0.1:80']
end

haproxy_backend 'back-dynamic' do
  mode 'http'
  extra_options('use-fcgi-app' => 'php-fpm')
  server ['php-fpm 127.0.0.1:9000 proto fcgi']
end

haproxy_service 'haproxy'
