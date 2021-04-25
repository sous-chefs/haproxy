use 'partial/_config_file'
use 'partial/_extra_options'

property :nameserver, Array,
          description: 'DNS server description'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['resolvers'] ||= {}
  haproxy_config_resource.variables['resolvers'][new_resource.name] ||= {}
  haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'] ||= [] unless new_resource.nameserver.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'] << new_resource.nameserver unless new_resource.nameserver.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
