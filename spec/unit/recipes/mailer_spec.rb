require 'spec_helper'

describe 'haproxy_' do
  step_into :haproxy_mailer, :haproxy_frontend, :haproxy_install, :haproxy_backend
  platform 'ubuntu'

  context 'create a mailer, frontend and backend and verify config is created properly' do
    recipe do
      haproxy_install 'package'

      haproxy_mailer 'mymailer' do
        mailer ['smtp1 192.168.0.1:587', 'smtp2 192.168.0.2:587']
        timeout '20s'
      end

      haproxy_frontend 'admin' do
        bind '0.0.0.0:1337'
        mode 'http'
        use_backend ['admin0 if path_beg /admin0']
      end

      haproxy_backend 'admin' do
        server ['admin0 10.0.0.10:80 check weight 1 maxconn 100']
        extra_options('email-alert' => [ 'mailers mymailers',
                                         'from test1@horms.org',
                                         'to test2@horms.org' ])
      end
    end

    cfg_content = [
      'mailers mymailer',
      '  mailer smtp1 192.168.0.1:587',
      '  mailer smtp2 192.168.0.2:587',
      '  timeout mail 20s',
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
      '  email-alert mailers mymailers',
      '  email-alert from test1@horms.org',
      '  email-alert to test2@horms.org',
    ]

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{cfg_content.join('\n')}/) }
  end
end
