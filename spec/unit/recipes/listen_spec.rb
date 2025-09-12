require 'spec_helper'

describe 'haproxy_listen' do
  step_into :haproxy_listen, :haproxy_install
  platform 'ubuntu'

  context 'create template with a listen resource' do
    recipe do
      haproxy_listen 'admin' do
        bind '0.0.0.0:1337' => ''
        mode 'http'
        stats uri: '/',
              realm: 'Haproxy-Statistics',
              auth: 'user:pwd'
        http_request 'add-header X-Proto http'
        http_response 'set-header Expires %[date(3600),http_date]'
        default_backend 'servers'
        extra_options('bind-process' => 'odd')
        server ['admin0 10.0.0.10:80 check weight 1 maxconn 100',
                'admin1 10.0.0.10:80 check weight 1 maxconn 100']
      end
    end

    cfg_content = [
      'listen admin',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  stats uri /',
      '  stats realm Haproxy-Statistics',
      '  stats auth user:pwd',
      '  http-request add-header X-Proto http',
      '  http-response set-header Expires %\[date\(3600\),http_date]',
      '  default_backend servers',
      '  bind-process odd',
      '  server admin0 10.0.0.10:80 check weight 1 maxconn 100',
      '  server admin1 10.0.0.10:80 check weight 1 maxconn 100',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end

  context 'option parameter with array of options' do
    recipe do
      haproxy_install 'package'

      haproxy_listen 'test_options' do
        bind '0.0.0.0:1337'
        mode 'http'
        option %w(dontlog-normal forwardfor)
      end
    end

    cfg_content = [
      'listen test_options',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  option dontlog-normal',
      '  option forwardfor',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end

  context 'extra options hash with disabled option' do
    recipe do
      haproxy_install 'package'

      haproxy_listen 'disabled' do
        bind '0.0.0.0:1337'
        mode 'http'
        extra_options('disabled': '')
      end
    end

    cfg_content = [
      'listen disabled',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  disabled',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end

  context 'extra options http-request rule should be placed before use_backend rule' do
    recipe do
      haproxy_install 'package'

      haproxy_listen 'use_backend' do
        bind '0.0.0.0:1337'
        mode 'http'
        use_backend ['admin0 if path_beg /admin0']
        extra_options('http-request' => 'add-header Test Value')
      end
    end

    cfg_content = [
      'listen use_backend',
      '  mode http',
      '  bind 0.0.0.0:1337',
      '  http-request add-header Test Value',
      '  use_backend admin0 if path_beg /admin0',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
    it { is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content(%r{use_backend admin0 if path_beg /admin0.*http-request add-header Test Value}m) }
  end
end
