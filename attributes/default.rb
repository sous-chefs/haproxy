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
default['haproxy']['syslog']['length'] = nil
default['haproxy']['syslog']['facilities'] = {
  'local0' => nil,
  'local1' => 'notice',
}

default['haproxy']['x_forwarded_for'] = false
default['haproxy']['cookie'] = nil

default['haproxy']['member_max_connections'] = 100
default['haproxy']['frontend_max_connections'] = 2000
default['haproxy']['frontend_ssl_max_connections'] = 2000

default['haproxy']['pool_members'] = {}
default['haproxy']['pool_members_option'] = nil
default['haproxy']['listeners'] = {
  'listen' => {},
  'frontend' => {},
  'backend' => {},
}

# We keep the init script for sysvinit
default['haproxy']['poise_service']['options'] = {
  sysvinit: {
    template: 'haproxy:haproxy-init.erb',
    hostname:   node['hostname'],
    conf_dir:   '/etc/haproxy',
    pid_file:  '/var/run/haproxy.pid',
  },
  systemd: {
    reload_signal: 'USR2',
    restart_mode: 'always',
    after_target: 'network',
    auto_reload: true,
  },
}
