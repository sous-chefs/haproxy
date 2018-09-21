require 'spec_helper'

describe 'haproxy_listen' do
  step_into :haproxy_listen, :haproxy_install
  platform 'ubuntu'

  context 'create template with a listen resource' do
    recipe do
      haproxy_install 'package'

      haproxy_listen 'admin' do
        bind '0.0.0.0:1337'
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

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/listen/) }
    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/bind-process odd/) }
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

    it('should render content with disabled') do
      is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/disabled/)
    end
  end
end
