property :timeout, Hash, default: { client: '10s', server: '10s', connect: '10s' }
property :log, String, default: 'global'
property :mode, String, default: 'http', equal_to: %w(http tcp health)
property :balance, String, default: 'roundrobin', equal_to: %w(roundrobin static-rr leastconn first source uri url_param header rdp-cookie)
property :option, Array, default: %w(httplog dontlognull redispatch tcplog)
property :stats, Hash, default: {}
property :maxconn, Integer
property :extra_options, Hash
property :haproxy_retries, Integer
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :conf_template_source, String, default: 'haproxy.cfg.erb'
property :conf_cookbook, String, default: 'haproxy'
property :conf_file_mode, String, default: '0644'
property :hash_type, [String, nil], equal_to: ['consistent', 'map-based', nil]

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['defaults'] ||= {}
  haproxy_config_resource.variables['defaults']['timeout'] ||= {}
  haproxy_config_resource.variables['defaults']['timeout'] = new_resource.timeout unless new_resource.timeout.nil?
  haproxy_config_resource.variables['defaults']['log'] ||= ''
  haproxy_config_resource.variables['defaults']['log'] << new_resource.log
  haproxy_config_resource.variables['defaults']['mode'] ||= ''
  haproxy_config_resource.variables['defaults']['mode'] << new_resource.mode
  haproxy_config_resource.variables['defaults']['balance'] ||= '' unless new_resource.balance.nil?
  haproxy_config_resource.variables['defaults']['balance'] << new_resource.balance unless new_resource.balance.nil?
  haproxy_config_resource.variables['defaults']['option'] ||= []
  (haproxy_config_resource.variables['defaults']['option'] << new_resource.option).flatten!
  haproxy_config_resource.variables['defaults']['stats'] ||= {}
  haproxy_config_resource.variables['defaults']['stats'].merge!(new_resource.stats)
  haproxy_config_resource.variables['defaults']['maxconn'] ||= '' unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['defaults']['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['defaults']['retries'] ||= '' unless new_resource.haproxy_retries.nil?
  haproxy_config_resource.variables['defaults']['retries'] << new_resource.haproxy_retries.to_s unless new_resource.haproxy_retries.nil?
  haproxy_config_resource.variables['defaults']['hash_type'] = new_resource.hash_type unless new_resource.hash_type.nil?
  haproxy_config_resource.variables['defaults']['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['defaults']['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
