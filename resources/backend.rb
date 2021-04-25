use 'partial/_config_file'
use 'partial/_extra_options'

property :mode, String,
          equal_to: %w(http tcp health),
          description: 'Set the running mode or protocol of the instance'

property :server, [String, Array],
          coerce: proc { |p| Array(p) },
          description: 'Servers the backend routes to'

property :tcp_request, [String, Array],
          coerce: proc { |p| Array(p) },
          description: 'HAProxy tcp-request settings'

property :reqrep, [String, Array],
          coerce: proc { |p| Array(p) },
          description: 'Replace a regular expression with a string in an HTTP request line'

property :reqirep, [String, Array],
          coerce: proc { |p| Array(p) },
          description: 'reqrep ignoring case'

property :acl, Array,
          description: 'Access control list items'

property :option, Array,
          description: 'Array of HAProxy option directives'

property :hash_type, String,
          equal_to: %w(consistent map-based),
          description: 'Specify a method to use for mapping hashes to servers'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['backend'] ||= {}

  haproxy_config_resource.variables['backend'][new_resource.name] ||= {}
  haproxy_config_resource.variables['backend'][new_resource.name]['mode'] = new_resource.mode if property_is_set?(:mode)

  if property_is_set?(:server)
    haproxy_config_resource.variables['backend'][new_resource.name]['server'] ||= []
    haproxy_config_resource.variables['backend'][new_resource.name]['server'].push(new_resource.server)
  end

  if property_is_set?(:tcp_request)
    haproxy_config_resource.variables['backend'][new_resource.name]['tcp_request'] ||= []
    haproxy_config_resource.variables['backend'][new_resource.name]['tcp_request'].push(new_resource.tcp_request)
  end

  haproxy_config_resource.variables['backend'][new_resource.name]['reqrep'] = new_resource.reqrep.flatten if property_is_set?(:reqrep)
  haproxy_config_resource.variables['backend'][new_resource.name]['reqirep'] = new_resource.reqirep.flatten if property_is_set?(:reqirep)

  if property_is_set?(:acl)
    haproxy_config_resource.variables['backend'][new_resource.name]['acl'] ||= []
    haproxy_config_resource.variables['backend'][new_resource.name]['acl'].push(new_resource.acl)
  end

  if property_is_set?(:option)
    haproxy_config_resource.variables['backend'][new_resource.name]['option'] ||= []
    haproxy_config_resource.variables['backend'][new_resource.name]['option'].push(new_resource.option)
  end

  haproxy_config_resource.variables['backend'][new_resource.name]['hash_type'] = new_resource.hash_type if property_is_set?(:hash_type)
  haproxy_config_resource.variables['backend'][new_resource.name]['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['backend'] ||= {}

  haproxy_config_resource.variables['backend'][new_resource.name] ||= {}
  haproxy_config_resource.variables['backend'].delete(new_resource.name) if haproxy_config_resource.variables['backend'].key?(new_resource.name)
end
