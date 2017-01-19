#
# Cookbook:: haproxy
# Default:: default
#
# Copyright:: 2010-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['haproxy']['conf_cookbook'] = 'haproxy'
default['haproxy']['conf_template_source'] = 'haproxy.cfg.erb'
default['haproxy']['user'] = 'haproxy'
default['haproxy']['group'] = 'haproxy'
default['haproxy']['package']['name'] = 'haproxy'

default['haproxy']['enable_default_http'] = true
default['haproxy']['mode'] = 'http'
default['haproxy']['ssl_mode'] = 'http'
default['haproxy']['incoming_address'] = '0.0.0.0'
default['haproxy']['incoming_port'] = 80
default['haproxy']['members'] = [{
  'hostname' => 'localhost',
  'ipaddress' => '127.0.0.1',
  'port' => 4000,
  'ssl_port' => 4000,
}, {
  'hostname' => 'localhost',
  'ipaddress' => '127.0.0.1',
  'port' => 4001,
  'ssl_port' => 4001,
}]
default['haproxy']['member_port'] = 8080
default['haproxy']['member_weight'] = 1
default['haproxy']['app_server_role'] = 'webserver'
default['haproxy']['defaults_retries'] = 3
default['haproxy']['balance_algorithm'] = 'roundrobin'
default['haproxy']['enable_ssl'] = false
default['haproxy']['ssl_incoming_address'] = '0.0.0.0'
default['haproxy']['ssl_incoming_port'] = 443
default['haproxy']['ssl_member_port'] = 8443
default['haproxy']['ssl_crt_path'] = nil
default['haproxy']['httpchk'] = nil
default['haproxy']['ssl_httpchk'] = nil
default['haproxy']['enable_admin'] = true
default['haproxy']['admin']['address_bind'] = '127.0.0.1'
default['haproxy']['admin']['port'] = 22_002
default['haproxy']['admin']['options'] = { 'stats' => 'uri /' }
default['haproxy']['enable_stats_socket'] = false
default['haproxy']['stats_socket_path'] = '/var/run/haproxy.sock'
default['haproxy']['stats_socket_user'] = node['haproxy']['user']
default['haproxy']['stats_socket_group'] = node['haproxy']['group']
default['haproxy']['stats_socket_level'] = 'user'
default['haproxy']['pid_file'] = '/var/run/haproxy.pid'
default['haproxy']['syslog']['length'] = nil
default['haproxy']['debug_options'] = 'quiet'

default['haproxy']['defaults_options'] = %w(httplog dontlognull redispatch)
default['haproxy']['x_forwarded_for'] = false
default['haproxy']['global_options'] = {}
# debug_options could be either "debug" or "quiet". "quiet" by default.
default['haproxy']['debug_options'] = 'quiet'
default['haproxy']['defaults_timeouts']['connect'] = '5s'
default['haproxy']['defaults_timeouts']['client'] = '50s'
default['haproxy']['defaults_timeouts']['server'] = '50s'
default['haproxy']['cookie'] = nil

default['haproxy']['global_max_connections'] = 4096
default['haproxy']['member_max_connections'] = 100
default['haproxy']['frontend_max_connections'] = 2000
default['haproxy']['frontend_ssl_max_connections'] = 2000

default['haproxy']['install_method'] = 'package'

# if source determine target
@target_os = 'generic'
if node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6
  @target_os = 'linux2628'
elif ( node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6) && ( node['kernel']['release'].split('.')[2].split('-').first.to_if > 28 )
  @target_os = 'linux2628'
elif ( node['kernel']['release'].split('.')[0..1].join('.').to_f > 2.6)
  @target_os = 'linux26'
end

default['haproxy']['source']['version'] = '1.6.11'
default['haproxy']['source']['url'] = 'http://www.haproxy.org/download/1.6/src/haproxy-1.6.11.tar.gz'
default['haproxy']['source']['checksum'] = '62fe982edb102a9f55205792bc14b0d05745cc7993cd6bee5d73cd3c5ae16ace'
default['haproxy']['source']['prefix'] = '/usr/local'
default['haproxy']['source']['target_os'] = @target_os
default['haproxy']['source']['target_cpu'] = node['kernel']['machine']
default['haproxy']['source']['target_arch'] = ''
default['haproxy']['source']['use_pcre'] = false
default['haproxy']['source']['use_openssl'] = false
default['haproxy']['source']['use_zlib'] = false

default['haproxy']['package']['version'] = nil

default['haproxy']['pool_members'] = {}
default['haproxy']['pool_members_option'] = nil
default['haproxy']['listeners'] = {
  'listen' => {},
  'frontend' => {},
  'backend' => {},
}

default['haproxy']['conf_dir'] = ::File.join(node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/', 'etc', 'haproxy')
default['haproxy']['global_prefix'] = node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/usr'
# We keep the init script for sysvinit
default['haproxy']['poise_service']['options'] = {
  sysvinit: {
    template: 'haproxy:haproxy-init.erb',
    hostname:   node['hostname'],
    conf_dir:   node['haproxy']['conf_dir'],
    pid_file:  '/var/run/haproxy.pid',
  },
  systemd: {
    reload_signal: 'USR2',
    restart_mode: 'always',
    after_target: 'network',
    auto_reload: true,
  },
}
