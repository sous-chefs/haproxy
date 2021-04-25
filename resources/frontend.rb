use 'partial/_config_file'
use 'partial/_extra_options'

property :bind, [String, Hash],
          default: '0.0.0.0:80',
          description: 'String - sets as given. Hash - joins with a space'

property :mode, String,
          equal_to: %w(http tcp health),
          description: 'Set the running mode or protocol of the instance'

property :maxconn, Integer,
          description: 'Sets the maximum per-process number of concurrent connections'

property :reqrep, [Array, String],
          description: 'Replace a regular expression with a string in an HTTP request line'

property :reqirep, [Array, String],
          description: 'reqrep ignoring case'

property :default_backend, String,
          description: 'Specify the backend to use when no "use_backend" rule has been matched'

property :use_backend, Array,
          description: 'Switch to a specific backend if/unless an ACL-based condition is matched'

property :acl, Array,
          description: 'Access control list items'

property :option, Array,
          description: 'Array of HAProxy option directives'

property :stats, Hash,
          description: 'Enable stats with various options'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['frontend'] ||= {}
  haproxy_config_resource.variables['frontend'][new_resource.name] ||= {}
  haproxy_config_resource.variables['frontend'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['default_backend'] << new_resource.default_backend unless new_resource.default_backend.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['bind'] = []
  if new_resource.bind.is_a? Hash
    new_resource.bind.map do |addresses, ports|
      (Array(addresses).product Array(ports)).each do |combo|
        haproxy_config_resource.variables['frontend'][new_resource.name]['bind'] << combo.join(' ').strip
      end
    end
  else
    haproxy_config_resource.variables['frontend'][new_resource.name]['bind'] << new_resource.bind
  end
  haproxy_config_resource.variables['frontend'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['stats'] ||= {} unless new_resource.stats.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['stats'].merge!(new_resource.stats) unless new_resource.stats.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['maxconn'] ||= '' unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['reqrep'] = [new_resource.reqrep].flatten unless new_resource.reqrep.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['reqirep'] = [new_resource.reqirep].flatten unless new_resource.reqirep.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['use_backend'] ||= [] unless new_resource.use_backend.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['use_backend'] << new_resource.use_backend unless new_resource.use_backend.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['frontend'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
