require 'spec_helper'

describe 'haproxy_fastcgi' do
  step_into :haproxy_fastcgi, :haproxy_frontend, :haproxy_install, :haproxy_backend
  platform 'ubuntu'

  context 'create a fastcgi resource, frontend and backend and verify config is created properly' do
    recipe do
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
        server ['www A.B.C.D:80']
      end

      haproxy_backend 'back-dynamic' do
        mode 'http'
        extra_options('use-fcgi-app' => 'php-fpm')
        server ['php-fpm A.B.C.D:9000 proto fcgi']
      end
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
      '  server www A.B.C.D:80',
      '',
      '',
      'backend back-dynamic',
      '  mode http',
      '  server php-fpm A.B.C.D:9000 proto fcgi',
      '  use-fcgi-app php-fpm',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end
end
