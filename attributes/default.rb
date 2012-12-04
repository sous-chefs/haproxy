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
default['haproxy']['pid_file'] = "/var/run/haproxy.pid"

default['haproxy']['defaults_options'] = ["httplog", "dontlognull", "redispatch"]
default['haproxy']['x_forwarded_for'] = false
default['haproxy']['defaults_timeouts']['connect'] = "5s"
default['haproxy']['defaults_timeouts']['client'] = "50s"
default['haproxy']['defaults_timeouts']['server'] = "50s"

default['haproxy']['user'] = "haproxy"
default['haproxy']['group'] = "haproxy"

default['haproxy']['global_max_connections'] = 4096
default['haproxy']['member_max_connections'] = 100
default['haproxy']['frontend_max_connections'] = 2000
default['haproxy']['frontend_ssl_max_connections'] = 2000
