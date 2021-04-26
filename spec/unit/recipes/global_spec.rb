require 'spec_helper'

describe 'haproxy_config_global' do
  step_into :haproxy_config_global
  platform 'ubuntu'

  context 'create haproxy config global' do
    recipe do
      haproxy_config_global 'global'
    end

    cfg_content = <<CFG
global
  user haproxy
  group haproxy
  log /dev/log syslog info
  log-tag haproxy
  daemon
  quiet
  stats socket /var/run/haproxy.sock user haproxy group haproxy
  stats timeout 2m
  maxconn 4096
  pidfile /var/run/haproxy.pid
CFG

    it { is_expected.to render_file('/etc/haproxy/haproxy.cfg').with_content(cfg_content) }
  end
end
