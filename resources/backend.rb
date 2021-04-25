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

property :reqrep, [Array, String],
          description: 'Replace a regular expression with a string in an HTTP request line'

property :reqirep, [Array, String],
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
  haproxy_config_resource.variables['backend'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['tcp_request'] ||= [] unless new_resource.tcp_request.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['tcp_request'] << new_resource.tcp_request unless new_resource.tcp_request.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['reqrep'] = [new_resource.reqrep].flatten unless new_resource.reqrep.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['reqirep'] = [new_resource.reqirep].flatten unless new_resource.reqirep.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['hash_type'] = new_resource.hash_type unless new_resource.hash_type.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['backend'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
