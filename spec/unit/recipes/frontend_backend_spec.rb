require 'spec_helper'

describe 'haproxy_' do
  step_into :haproxy_frontend, :haproxy_install, :haproxy_backend
  platform 'ubuntu'

  context 'create frontend and backend with http-request rule placed before use_backend' do
    recipe do
      haproxy_install 'package'

      haproxy_frontend 'admin' do
        bind '0.0.0.0:1337'
        mode 'http'
        use_backend ['admin0 if path_beg /admin0']
        extra_options(
          'http-request' => 'add-header Test Value',
          'tcp-request content' => 'content value',
          'monitor fail' => 'monitor value',
          'block' => 'block value',
          'reqdeny' => 'reqdeny value',
          'reqadd' => 'reqadd value',
          'redirect' => 'redirect value',
          'tcp-request session' => 'session value',
          'tcp-request connection' => 'connection value'
          )
      end

      haproxy_backend 'admin' do
        server ['admin0 10.0.0.10:80 check weight 1 maxconn 100']
        tcp_request ['content content backend']
        extra_options(
          'http-request' => 'add-header Backend Value',
          'block' => 'block backend',
          'reqadd' => 'reqadd backend',
          'redirect' => 'redirect backend',
          'reqdeny' => 'reqdeny backend'
          )
      end
    end

    it('should render content with http-request rule before use_backend') do
      is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/frontend admin/)

      is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(%r{\
^  tcp-request connection connection value$\n\
^  tcp-request session session value$\n\
^  tcp-request content content value$\n\
^  monitor fail monitor value$\n\
^  block block value$\n\
^  http-request add-header Test Value$\n\
^  reqdeny reqdeny value$\n\
^  reqadd reqadd value$\n\
^  redirect redirect value$\n\
^  use_backend admin0 if path_beg /admin0}m)

      is_expected.not_to render_file('/etc/haproxy/haproxy.cfg').with_content(%r{use_backend admin0 if path_beg /admin0.*http-request add-header Test Value}m)

      is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(%r{\
^  tcp-request content content backend$\n\
^  block block backend$\n\
^  http-request add-header Backend Value$\n\
^  reqdeny reqdeny backend$\n\
^  reqadd reqadd backend$\n\
^  redirect redirect backend$}m)
    end
  end
end
