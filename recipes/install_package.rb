#
# Cookbook Name:: haproxy
# Recipe:: install_package
#
# Copyright 2009, Chef Software, Inc.
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

package "haproxy" do
  version node['haproxy']['package']['version'] if node['haproxy']['package']['version']
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
    :prefix => "/usr"
  )
end
