use 'partial/_config_file'
use 'partial/_extra_options'

property :timeout, Hash,
          default: { client: '10s', server: '10s', connect: '10s' },
          description: 'Default HAProxy timeout values'

property :log, String,
          default: 'global',
          description: 'Enable per-instance logging of events and traffic'

property :mode, String,
          default: 'http',
          equal_to: %w(http tcp health),
          description: 'Set the running mode or protocol of the instance'

property :balance, String,
          default: 'roundrobin',
          equal_to: %w(roundrobin static-rr leastconn first source uri url_param header rdp-cookie),
          description: 'Define the load balancing algorithm to be used in a backend'

property :option, Array,
          default: %w(httplog dontlognull redispatch tcplog),
          description: 'Array of HAProxy option directives'

property :stats, Hash,
          default: {},
          description: 'Enable HAProxy statistics'

property :maxconn, Integer,
          description: 'Sets the maximum per-process number of concurrent connections'

property :haproxy_retries, Integer,
          description: 'Set the number of retries to perform on a server after a connection failure'

property :hash_type, [String, nil],
          equal_to: ['consistent', 'map-based', nil],
          description: 'Specify a method to use for mapping hashes to servers'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['defaults'] ||= {}

  haproxy_config_resource.variables['defaults']['timeout'] = new_resource.timeout
  haproxy_config_resource.variables['defaults']['log'] = new_resource.log
  haproxy_config_resource.variables['defaults']['mode'] = new_resource.mode
  haproxy_config_resource.variables['defaults']['balance'] = new_resource.balance

  haproxy_config_resource.variables['defaults']['option'] ||= []
  haproxy_config_resource.variables['defaults']['option'].push(new_resource.option).flatten!

  haproxy_config_resource.variables['defaults']['stats'] = new_resource.stats
  haproxy_config_resource.variables['defaults']['maxconn'] = new_resource.maxconn.to_s if property_is_set?(:maxconn)
  haproxy_config_resource.variables['defaults']['retries'] = new_resource.haproxy_retries.to_s if property_is_set?(:haproxy_retries)
  haproxy_config_resource.variables['defaults']['hash_type'] = new_resource.hash_type if property_is_set?(:hash_type)
  haproxy_config_resource.variables['defaults']['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end
