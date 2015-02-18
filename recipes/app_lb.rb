#
# Cookbook Name:: haproxy
# Recipe:: app_lb
#
# Copyright 2011, Chef Software, Inc.
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

pool_members = search("node", "role:#{node['haproxy']['app_server_role']} AND chef_environment:#{node.chef_environment}") || []

# load balancer may be in the pool
pool_members << node if node.run_list.roles.include?(node['haproxy']['app_server_role'])

# we prefer connecting via local_ipv4 if
# pool members are in the same cloud
# TODO refactor this logic into library...see COOK-494
pool_members.map! do |member|
  server_ip = begin
    if member.attribute?('cloud')
      if node.attribute?('cloud') && (member['cloud']['provider'] == node['cloud']['provider'])
         member['cloud']['local_ipv4']
      else
        member['cloud']['public_ipv4']
      end
    else
      member['ipaddress']
    end
  end
  {:ipaddress => server_ip, :hostname => member['hostname']}
end

pool_members.sort! do |a,b|
  a[:hostname].downcase <=> b[:hostname].downcase
end

pool = ["options httpchk #{node['haproxy']['httpchk']}"] if node['haproxy']['httpchk']
servers = pool_members.uniq.map do |s|
  "#{s[:hostname]} #{s[:ipaddress]}:#{node['haproxy']['member_port']} weight 1 maxconn #{node['haproxy']['member_max_connections']} check"
end
haproxy_lb 'servers-http' do
  type 'backend'
  servers servers
  params pool
end

if node['haproxy']['enable_ssl']
  pool = ["option ssl-hello-chk"]
  pool << ["options httpchk #{node['haproxy']['ssl_httpchk']}"] if node['haproxy']['ssl_httpchk']
  servers = pool_members.uniq.map do |s|
    "#{s[:hostname]} #{s[:ipaddress]}:#{node['haproxy']['ssl_member_port']} weight 1 maxconn #{node['haproxy']['member_max_connections']} check"
  end
  haproxy_lb 'servers-http' do
    type 'backend'
    mode 'tcp'
    servers servers
    params pool
  end
end

include_recipe "haproxy::install_#{node['haproxy']['install_method']}"
