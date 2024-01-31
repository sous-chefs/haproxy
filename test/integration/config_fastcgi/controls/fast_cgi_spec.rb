title 'FastCGI should be configurable'

include_controls 'haproxy-common'

cfg_content = [
  'fcgi-app php-fpm',
  '  docroot /var/www/my-app',
  '  index index.php',
  '  log-stderr global',
  '  option keep-conn',
  '  path-info \^\(\/\.\+\\\.php\)\(\/\.\*\)\?\$',
  '',
  '',
  'frontend front-http',
  '  mode http',
  '  default_backend back-static',
  '  bind \*:80',
  '  use_backend back-dynamic if \{ path_reg \^\/\.\+\\\.php\(\/\.\*\)\?\$ \}',
  '',
  '',
  'backend back-static',
  '  mode http',
  '  server www 127.0.0.1:80',
  '',
  '',
  'backend back-dynamic',
  '  mode http',
  '  server php-fpm 127.0.0.1:9000 proto fcgi',
  '  use-fcgi-app php-fpm',
]

describe file('/etc/haproxy/haproxy.cfg') do
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end
