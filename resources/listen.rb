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

property :stats, Hash,
          description: 'Enable stats with various options'

property :http_request, [Array, String],
          coerce: proc { |p| Array(p).flatten },
          description: 'Switch to a specific backend if/unless an ACL-based condition is matched'

property :http_response, String,
          description: 'Switch to a specific backend if/unless an ACL-based condition is matched'

property :reqrep, [Array, String],
          coerce: proc { |p| Array(p).flatten },
          description: 'Replace a regular expression with a string in an HTTP request line'

property :reqirep, [Array, String],
          coerce: proc { |p| Array(p).flatten },
          description: 'reqrep ignoring case'

property :default_backend, String,
          description: 'Specify the backend to use when no "use_backend" rule has been matched'

property :use_backend, Array,
          description: 'Switch to a specific backend if/unless an ACL-based condition is matched'

property :acl, Array,
          description: 'Access control list items'

property :server, Array,
          description: 'Servers the listen section routes to'

property :hash_type, String,
          equal_to: %w(consistent map-based),
          description: 'Specify a method to use for mapping hashes to servers'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['listen'] ||= {}

  haproxy_config_resource.variables['listen'][new_resource.name] ||= {}
  haproxy_config_resource.variables['listen'][new_resource.name]['bind'] ||= []

  if new_resource.bind.is_a?(Hash)
    new_resource.bind.map do |addresses, ports|
      Array(addresses).product(Array(ports)).each do |combo|
        haproxy_config_resource.variables['listen'][new_resource.name]['bind'].push(combo.join(' ').strip)
      end
    end
  else
    haproxy_config_resource.variables['listen'][new_resource.name]['bind'].push(new_resource.bind)
  end

  haproxy_config_resource.variables['listen'][new_resource.name]['mode'] = new_resource.mode if property_is_set?(:mode)
  haproxy_config_resource.variables['listen'][new_resource.name]['maxconn'] = new_resource.maxconn.to_s if property_is_set?(:mode)
  haproxy_config_resource.variables['listen'][new_resource.name]['stats'] = new_resource.stats if property_is_set?(:stats)
  haproxy_config_resource.variables['listen'][new_resource.name]['http_request'] = new_resource.http_request if property_is_set?(:http_request)
  haproxy_config_resource.variables['listen'][new_resource.name]['http_response'] = new_resource.http_response if property_is_set?(:http_response)
  haproxy_config_resource.variables['listen'][new_resource.name]['reqrep'] = new_resource.reqrep if property_is_set?(:reqrep)
  haproxy_config_resource.variables['listen'][new_resource.name]['reqirep'] = new_resource.reqirep if property_is_set?(:reqirep)

  if property_is_set?(:use_backend)
    haproxy_config_resource.variables['listen'][new_resource.name]['use_backend'] ||= []
    haproxy_config_resource.variables['listen'][new_resource.name]['use_backend'].push(new_resource.use_backend)
  end

  if property_is_set?(:acl)
    haproxy_config_resource.variables['listen'][new_resource.name]['acl'] ||= []
    haproxy_config_resource.variables['listen'][new_resource.name]['acl'].push(new_resource.acl)
  end

  haproxy_config_resource.variables['listen'][new_resource.name]['default_backend'] = new_resource.default_backend if property_is_set?(:default_backend)

  if property_is_set?(:server)
    haproxy_config_resource.variables['listen'][new_resource.name]['server'] ||= []
    haproxy_config_resource.variables['listen'][new_resource.name]['server'].push(new_resource.server)
  end

  haproxy_config_resource.variables['listen'][new_resource.name]['hash_type'] = new_resource.hash_type if property_is_set?(:hash_type)
  haproxy_config_resource.variables['listen'][new_resource.name]['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['listen'] ||= {}

  haproxy_config_resource.variables['listen'][new_resource.name] ||= {}
  haproxy_config_resource.variables['listen'].delete(new_resource.name) if haproxy_config_resource.variables['listen'].key?(new_resource.name)
end
