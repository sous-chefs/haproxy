#
# Cookbook Name:: haproxy
# Recipe:: install_from_source
#
# Copyright 2011, Opscode, Inc.
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

include_recipe "build-essential"

remote_file "#{node['haproxy']['source']['install_prefix_root']}/share/haproxy-#{node['haproxy']['source']['version']}.tar.gz" do
  source "http://haproxy.1wt.eu/download/#{node['haproxy']['source']['version_branch']}/src/devel/haproxy-#{node['haproxy']['source']['version']}.tar.gz"
  owner node['haproxy']['source']['user']
end

execute "tar xvzf #{node['haproxy']['source']['install_prefix_root']}/share/haproxy-#{node['haproxy']['source']['version']}.tar.gz" do
  user node['haproxy']['source']['user']
  cwd "#{node['haproxy']['source']['install_prefix_root']}/share"
end

execute "make TARGET=generic && make install" do
  user node['haproxy']['source']['user']
  cwd "#{node['haproxy']['source']['install_prefix_root']}/share/haproxy-#{node['haproxy']['source']['version']}"
end

group "haproxy"

user "haproxy" do
  home "/home/haproxy"
  shell "/bin/false"
  gid "haproxy"
end

template "/etc/default/haproxy" do
  source "haproxy-default.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/init.d/haproxy" do
  source "haproxy-initd.erb"
  owner "root"
  group "root"
  mode 0755
  variables :executable => "#{node['haproxy']['source']['install_prefix_root']}/share/haproxy-#{node['haproxy']['source']['version']}/haproxy"
end

directory "/etc/haproxy/errors" do
  owner "root"
  group "root"
  mode '755'
  recursive true
end
