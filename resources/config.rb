#
# Cookbook Name:: haproxy
# Resource:: config
#
# Copyright (C) 2017 Webb Agile Solutions Ltd.
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

property :name, String, name_attribute: true
property :conf_dir, String, default: lazy { node['haproxy']['conf_dir'] }
property :conf_cookbook, String, default: lazy { node['haproxy']['conf_cookbook'] }
property :conf_template_source, String, default: lazy { node['haproxy']['conf_template_source'] }
property :defaults_timeouts, String, default: lazy { node['haproxy']['defaults_timeouts'] }
property :defaults_options, String, default: lazy { node['haproxy']['defaults_options'] }
property :config, String, required: true

action :create do
  template "#{new_resource.conf_dir}/haproxy.cfg" do
    cookbook new_resource.conf_cookbook
    source new_resource.conf_template_source
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      defaults_options: defaults_options,
      defaults_timeouts: defaults_timeouts
      config: config
    )
  end
end
