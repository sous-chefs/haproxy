#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe 'build-essential'

package 'libpcre3-dev' do
  only_if { node['haproxy']['source']['use_pcre'] }
end

package 'libssl-dev' do
  only_if { node['haproxy']['source']['use_openssl'] }
end

package 'zlib1g-dev' do
  only_if { node['haproxy']['source']['use_zlib'] }
end

node.set['haproxy']['conf_dir'] = "#{node['haproxy']['source']['prefix']}/etc"

remote_file "#{Chef::Config[:file_cache_path]}/haproxy-#{node['haproxy']['source']['version']}.tar.gz" do
  source node['haproxy']['source']['url']
  checksum node['haproxy']['source']['checksum']
  action :create_if_missing
end

make_cmd = "make TARGET=#{node['haproxy']['source']['target_os']}"
make_cmd << " CPU=#{node['haproxy']['source']['target_cpu' ]}" unless node['haproxy']['source']['target_cpu'].empty?
make_cmd << " ARCH=#{node['haproxy']['source']['target_arch']}" unless node['haproxy']['source']['target_arch'].empty?
make_cmd << " USE_PCRE=1" if node['haproxy']['source']['use_pcre']
make_cmd << " USE_OPENSSL=1" if node['haproxy']['source']['use_openssl']
make_cmd << " USE_ZLIB=1" if node['haproxy']['source']['use_zlib']

bash "compile_haproxy" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xzf haproxy-#{node['haproxy']['source']['version']}.tar.gz
    cd haproxy-#{node['haproxy']['source']['version']}
    #{make_cmd} && make install PREFIX=#{node['haproxy']['source']['prefix']}
  EOH
  creates "#{node['haproxy']['source']['prefix']}/sbin/haproxy"
end

user "haproxy" do
  comment "haproxy system account"
  system true
  shell "/bin/false"
end

directory node['haproxy']['conf_dir']

template "/etc/init.d/haproxy" do
  source "haproxy-init.erb"
  owner "root"
  group "root"
  mode 00755
  variables(
    :hostname => node['hostname'],
    :conf_dir => node['haproxy']['conf_dir'],
    :prefix => node['haproxy']['source']['prefix']
  )
end
