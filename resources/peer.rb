use 'partial/_config_file'
use 'partial/_extra_options'

property :bind, [String, Hash],
          description: 'String - sets as given. Hash - joins with a space. HAProxy version >= 2.0'

property :state, String,
          equal_to: %w(enabled disabled),
          description: 'Set the state of the peers'

property :server, Array,
          description: 'Servers in the peer'

property :default_bind, String,
          description: 'Defines the binding parameters for the local peer, excepted its address'

property :default_server, String,
          description: 'Change default options for a server'

property :table, Array,
          description: 'Configure a stickiness table'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['peer'] ||= {}

  haproxy_config_resource.variables['peer'][new_resource.name] ||= {}
  haproxy_config_resource.variables['peer'][new_resource.name]['bind'] = new_resource.bind if property_is_set?(:bind)
  haproxy_config_resource.variables['peer'][new_resource.name]['state'] = new_resource.state if property_is_set?(:state)

  if property_is_set?(:server)
    haproxy_config_resource.variables['peer'][new_resource.name]['server'] ||= []
    haproxy_config_resource.variables['peer'][new_resource.name]['server'].push(new_resource.server)
  end

  haproxy_config_resource.variables['peer'][new_resource.name]['default_bind'] = new_resource.default_bind if property_is_set?(:default_bind)
  haproxy_config_resource.variables['peer'][new_resource.name]['default_server'] = new_resource.default_server if property_is_set?(:default_server)

  if property_is_set?(:table)
    haproxy_config_resource.variables['peer'][new_resource.name]['table'] ||= []
    haproxy_config_resource.variables['peer'][new_resource.name]['table'].push(new_resource.table)
  end

  haproxy_config_resource.variables['peer'][new_resource.name]['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['peer'] ||= {}

  haproxy_config_resource.variables['peer'][new_resource.name] ||= {}
  haproxy_config_resource.variables['peer'].delete(new_resource.name) if haproxy_config_resource.variables['peer'].key?(new_resource.name)
end
