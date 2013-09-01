#
# Cookbook Name:: haproxy
# Default:: default
#
# Copyright 2010, Opscode, Inc.
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

default['haproxy']['incoming_address'] = "0.0.0.0"
default['haproxy']['incoming_port'] = 80
default['haproxy']['member_port'] = 8080
default['haproxy']['app_server_role'] = "webserver"
default['haproxy']['balance_algorithm'] = "roundrobin"
default['haproxy']['enable_ssl'] = false
default['haproxy']['ssl_incoming_address'] = "0.0.0.0"
default['haproxy']['ssl_incoming_port'] = 443
default['haproxy']['ssl_member_port'] = 8443
default['haproxy']['httpchk'] = nil
default['haproxy']['ssl_httpchk'] = nil
default['haproxy']['enable_admin'] = true
default['haproxy']['admin']['address_bind'] = "127.0.0.1"
default['haproxy']['admin']['port'] = 22002
default['haproxy']['enable_stats_socket'] = false
default['haproxy']['stats_socket_path'] = "/var/run/haproxy.sock"
default['haproxy']['pid_file'] = "/var/run/haproxy.pid"

default['haproxy']['defaults_options'] = ["httplog", "dontlognull", "redispatch"]
default['haproxy']['x_forwarded_for'] = false
default['haproxy']['defaults_timeouts']['connect'] = "5s"
default['haproxy']['defaults_timeouts']['client'] = "50s"
default['haproxy']['defaults_timeouts']['server'] = "50s"
default['haproxy']['cookie'] = nil

default['haproxy']['user'] = "haproxy"
default['haproxy']['group'] = "haproxy"

default['haproxy']['global_max_connections'] = 4096
default['haproxy']['member_max_connections'] = 100
default['haproxy']['frontend_max_connections'] = 2000
default['haproxy']['frontend_ssl_max_connections'] = 2000

default['haproxy']['install_method'] = 'package'
default['haproxy']['conf_dir'] = '/etc/haproxy'

default['haproxy']['source']['version'] = '1.4.22'
default['haproxy']['source']['url'] = 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.22.tar.gz'
default['haproxy']['source']['checksum'] = 'ba221b3eaa4d71233230b156c3000f5c2bd4dace94d9266235517fe42f917fc6'
default['haproxy']['source']['prefix'] = '/usr/local'
default['haproxy']['source']['target_os'] = 'generic'
default['haproxy']['source']['target_cpu'] = ''
default['haproxy']['source']['target_arch'] = ''
default['haproxy']['source']['use_pcre'] = false
