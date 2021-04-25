use 'partial/_config_file'

property :cache_name, String,
          name_property: true,
          description: 'Name of the cache'

property :total_max_size, Integer,
          description: 'Define the size in RAM of the cache in megabytes'

property :max_object_size, Integer,
          description: 'Define the maximum size of the objects to be cached'

property :max_age, Integer,
          description: 'Define the maximum expiration duration in seconds'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['cache'] ||= {}

  haproxy_config_resource.variables['cache'][new_resource.cache_name] ||= {}
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['total_max_size'] = new_resource.total_max_size if property_is_set?(:total_max_size)
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['max_object_size'] = new_resource.max_object_size if property_is_set?(:max_object_size)
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['max_age'] = new_resource.max_age if property_is_set?(:max_age)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['cache'] ||= {}

  haproxy_config_resource.variables['cache'][new_resource.cache_name] ||= {}
  haproxy_config_resource.variables['cache'].delete(new_resource.cache_name) if haproxy_config_resource.variables['cache'].key?(new_resource.cache_name)
end
