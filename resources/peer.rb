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
  haproxy_config_resource.variables['peer'][new_resource.name]['bind'] ||= {}
  haproxy_config_resource.variables['peer'][new_resource.name]['bind'] = new_resource.bind unless new_resource.bind.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['state'] = new_resource.state unless new_resource.state.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['server'] ||= []
  haproxy_config_resource.variables['peer'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['default_bind'] = new_resource.default_bind unless new_resource.default_bind.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['default_server'] = new_resource.default_server unless new_resource.default_server.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['table'] ||= []
  haproxy_config_resource.variables['peer'][new_resource.name]['table'] << new_resource.table unless new_resource.table.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['peer'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
