title 'FastCGI should be configurable'

describe directory '/etc/haproxy' do
  it { should exist }
end

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
  it { should exist }
  it { should be_owned_by 'haproxy' }
  it { should be_grouped_into 'haproxy' }
  its('content') { should match(/#{cfg_content.join('\n')}/) }
end

describe service('haproxy') do
  it { should be_running }
end
