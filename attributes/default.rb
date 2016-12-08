#
# Cookbook Name:: haproxy
# Default:: default
#
# Copyright 2010-2016, Chef Software, Inc.
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

default['haproxy']['enable_default_http'] = true
default['haproxy']['mode'] = 'http'
default['haproxy']['ssl_mode'] = 'http'
default['haproxy']['incoming_address'] = '0.0.0.0'
default['haproxy']['incoming_port'] = 80
default['haproxy']['members'] = [{
  'hostname' => 'localhost',
  'ipaddress' => '127.0.0.1',
  'port' => 4000,
  'ssl_port' => 4000
}, {
  'hostname' => 'localhost',
  'ipaddress' => '127.0.0.1',
  'port' => 4001,
  'ssl_port' => 4001
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

default['haproxy']['defaults_options'] = %w(httplog dontlognull redispatch)
default['haproxy']['x_forwarded_for'] = false
default['haproxy']['global_options'] = {}
default['haproxy']['defaults_timeouts']['connect'] = '5s'
default['haproxy']['defaults_timeouts']['client'] = '50s'
default['haproxy']['defaults_timeouts']['server'] = '50s'
default['haproxy']['cookie'] = nil

default['haproxy']['global_max_connections'] = 4096
default['haproxy']['member_max_connections'] = 100
default['haproxy']['frontend_max_connections'] = 2000
default['haproxy']['frontend_ssl_max_connections'] = 2000

default['haproxy']['install_method'] = 'package'
default['haproxy']['conf_dir'] = '/etc/haproxy'

default['haproxy']['source']['version'] = '1.6.9'
default['haproxy']['source']['url'] = 'http://www.haproxy.org/download/1.6/src/haproxy-1.6.9.tar.gz'
default['haproxy']['source']['checksum'] = 'cf7d2fa891d2ae4aa6489fc43a9cadf68c42f9cb0de4801afad45d32e7dda133'
default['haproxy']['source']['prefix'] = '/usr/local'
default['haproxy']['source']['target_os'] = 'generic'
default['haproxy']['source']['target_cpu'] = ''
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
  'backend' => {}
}
