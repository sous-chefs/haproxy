require 'spec_helper'

describe 'haproxy_config_defaults' do
  step_into :haproxy_config_defaults
  platform 'ubuntu'

  context 'create a cache, frontend and backend and verify config is created properly' do
    recipe do
      haproxy_config_defaults 'default'
    end

    cfg_content = <<CFG
defaults
  timeout client 10s
  timeout server 10s
  timeout connect 10s
  log global
  mode http
  balance roundrobin
  option httplog
  option dontlognull
  option redispatch
  option tcplog
CFG

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(cfg_content) }
  end
end
