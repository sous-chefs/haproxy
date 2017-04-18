#
# Cookbook:: haproxy
# Recipe:: manual
#
# Copyright:: 2014-2016, Heavy Water Software Inc.
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

include_recipe "haproxy::install_#{node['haproxy']['install_method']}"

cookbook_file '/etc/default/haproxy' do
  source 'haproxy-default'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'poise_service[haproxy]', :delayed
end

if node['haproxy']['enable_admin']
  admin = node['haproxy']['admin']
  haproxy_lb 'admin' do
    bind "#{admin['address_bind']}:#{admin['port']}"
    mode 'http'
    parameters(admin['options'])
  end
end

conf = node['haproxy']
member_max_conn = conf['member_max_connections']
member_weight = conf['member_weight']

if conf['enable_default_http']
  haproxy_lb 'http' do
    type 'frontend'
    parameters('maxconn' => conf['frontend_max_connections'],
               'bind' => "#{conf['incoming_address']}:#{conf['incoming_port']}",
               'default_backend' => 'servers-http')
  end

  member_port = conf['member_port']
  pool = []
  pool << "option httpchk #{conf['httpchk']}" if conf['httpchk']
  pool << "cookie #{node['haproxy']['cookie']}" if node['haproxy']['cookie']
  servers = node['haproxy']['members'].map do |member|
    "#{member['hostname']} #{member['ipaddress']}:#{member['port'] || member_port} weight #{member['weight'] || member_weight} maxconn #{member['max_connections'] || member_max_conn} check #{node['haproxy']['pool_members_option']}"
  end
  haproxy_lb 'servers-http' do
    type 'backend'
    servers servers
    parameters pool
  end
end

if node['haproxy']['enable_ssl']
  bind = if node['haproxy']['ssl_crt_path']
           "#{node['haproxy']['ssl_incoming_address']}:#{node['haproxy']['ssl_incoming_port']} ssl crt #{node['haproxy']['ssl_crt_path']}"
         else
           "#{node['haproxy']['ssl_incoming_address']}:#{node['haproxy']['ssl_incoming_port']}"
         end

  haproxy_lb 'https' do
    type 'frontend'
    mode node['haproxy']['ssl_mode']
    parameters('maxconn' => node['haproxy']['frontend_ssl_max_connections'],
               'bind' => bind,
               'default_backend' => 'servers-https')
  end

  ssl_member_port = conf['ssl_member_port']
  pool = ['option ssl-hello-chk']
  pool << "option httpchk #{conf['ssl_httpchk']}" if conf['ssl_httpchk']
  pool << "cookie #{node['haproxy']['cookie']}" if node['haproxy']['cookie']
  servers = node['haproxy']['members'].map do |member|
    "#{member['hostname']} #{member['ipaddress']}:#{member['ssl_port'] || ssl_member_port} weight #{member['weight'] || member_weight} maxconn #{member['max_connections'] || member_max_conn} check #{node['haproxy']['pool_members_option']}"
  end
  haproxy_lb 'servers-https' do
    type 'backend'
    mode node['haproxy']['ssl_mode']
    servers servers
    parameters pool
  end
end

# Re-default user/group to account for role/recipe overrides
node.default['haproxy']['stats_socket_user'] = node['haproxy']['user']
node.default['haproxy']['stats_socket_group'] = node['haproxy']['group']

unless node['haproxy']['global_options'].is_a?(Hash)
  Chef::Log.error("Global options needs to be a Hash of the format: { 'option' => 'value' }. Please set node['haproxy']['global_options'] accordingly.")
end

haproxy_config 'Create haproxy.cfg' do
  action :create
  notifies :reload, 'poise_service[haproxy]', :delayed
end

poise_service_user node['haproxy']['user'] do
  home '/home/haproxy'
  group node['haproxy']['group']
  action :create
end

node.override['haproxy']['conf_dir'] = ::File.join(node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/', 'etc', 'haproxy')
node.override['haproxy']['global_prefix'] = node['haproxy']['install_method'].eql?('source') ? node['haproxy']['source']['prefix'] : '/usr'
if node['init_package'] == 'systemd'
  haproxy_systemd_wrapper = ::File.join(node['haproxy']['global_prefix'], 'sbin', 'haproxy-systemd-wrapper')
  haproxy_config_file = ::File.join(node['haproxy']['conf_dir'], 'haproxy.cfg')
  poise_service 'haproxy' do
    provider :systemd
    command "#{haproxy_systemd_wrapper} -f #{haproxy_config_file} -p /run/haproxy.pid $OPTIONS"
    options node['haproxy']['poise_service']['options']['systemd']
    action :enable
  end
else
  haproxy_command = ::File.join(node['haproxy']['global_prefix'], 'sbin', 'haproxy')
  haproxy_config_file = ::File.join(node['haproxy']['conf_dir'], 'haproxy.cfg')
  node.override['haproxy']['poise_service']['options']['sysvinit']['conf_dir'] = node['haproxy']['conf_dir']
  poise_service 'haproxy' do
    provider :sysvinit
    command haproxy_command
    options node['haproxy']['poise_service']['options']['sysvinit']
    action :enable
  end
end
