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

# Base attributes used when generating configuration using default LWRP
default['haproxy']['config']['global']['log']['127.0.0.1']['local0'] = :warn
default['haproxy']['config']['global']['log']['127.0.0.1']['local1'] = :notice
default['haproxy']['config']['defaults']['timeout']['client'] = '10s'
default['haproxy']['config']['defaults']['timeout']['client'] = '10s'
default['haproxy']['config']['defaults']['timeout']['server'] = '10s'
default['haproxy']['config']['defaults']['timeout']['connect'] = '10s'
default['haproxy']['config']['defaults']['options'] = []
