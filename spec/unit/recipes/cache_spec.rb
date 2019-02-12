require 'spec_helper'

describe 'haproxy_' do
  step_into :haproxy_cache, :haproxy_frontend, :haproxy_install, :haproxy_backend
  platform 'ubuntu'

  context 'create a cache, frontend and backend and verify config is created properly' do
    recipe do
      haproxy_install 'package'

      haproxy_cache 'test' do
        total_max_size 4
        max_age 60
      end

      haproxy_frontend 'admin' do
        bind '0.0.0.0:1337'
        mode 'http'
        use_backend ['admin0 if path_beg /admin0']
        extra_options('http-request' => 'cache-use test', 'http-response' => 'cache-store test')
      end

      haproxy_backend 'admin' do
        server ['admin0 10.0.0.10:80 check weight 1 maxconn 100']
      end
    end

    cfg_content = [
      'cache test',
      '  total-max-size 4',
      '  max-age 60',
      '',
      '',
      'frontend admin',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  http-request cache-use test',
      '  use_backend admin0 if path_beg /admin0',
      '  http-response cache-store test',
      '',
      '',
      'backend admin',
      '  server admin0 10.0.0.10:80 check weight 1 maxconn 100',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end
end
