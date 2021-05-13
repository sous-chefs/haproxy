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

  if property_is_set?(:nameserver)
    haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'] ||= []
    haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'].push(new_resource.nameserver)
  end

  haproxy_config_resource.variables['resolvers'][new_resource.name]['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['resolvers'] ||= {}

  haproxy_config_resource.variables['resolvers'][new_resource.name] ||= {}
  haproxy_config_resource.variables['resolvers'].delete(new_resource.name) if haproxy_config_resource.variables['resolvers'].key?(new_resource.name)
end
