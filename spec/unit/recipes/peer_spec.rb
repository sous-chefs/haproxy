require 'spec_helper'

describe 'haproxy_' do
  step_into :haproxy_peer, :haproxy_frontend, :haproxy_install, :haproxy_backend
  platform 'ubuntu'

  context 'create a peers section, frontend and backend and verify config is created properly' do
    recipe do
      haproxy_install 'package'

      haproxy_peer 'mypeers' do
        bind('0.0.0.0:1336' => '')
        default_server 'ssl verify none'
        server ['hostA 127.0.0.10:10000']
      end

      haproxy_frontend 'admin' do
        bind '0.0.0.0:1337'
        mode 'http'
        use_backend ['admin0 if path_beg /admin0']
      end

      haproxy_backend 'admin' do
        extra_options('stick-table' => 'type string len 32 size 100k expire 30m peers mypeers')
        server ['admin0 10.0.0.10:80 check weight 1 maxconn 100']
      end
    end

    cfg_content = [
      'peers mypeers',
      '  bind 0.0.0.0:1336',
      '  server hostA 127.0.0.10:10000',
      '  default-server ssl verify none',
      '',
      '',
      'frontend admin',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  use_backend admin0 if path_beg /admin0',
      '',
      '',
      'backend admin',
      '  server admin0 10.0.0.10:80 check weight 1 maxconn 100',
      '  stick-table type string len 32 size 100k expire 30m peers mypeers',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end
end
