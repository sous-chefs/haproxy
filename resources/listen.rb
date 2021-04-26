property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :mode, String, equal_to: %w(http tcp health)
property :bind, [String, Hash], default: '0.0.0.0:80'
property :maxconn, Integer
property :stats, Hash
property :http_request, [Array, String]
property :http_response, String
property :reqrep, [Array, String]
property :reqirep, [Array, String]
property :default_backend, String
property :use_backend, Array
property :acl, Array
property :extra_options, Hash
property :server, Array
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :conf_template_source, String, default: 'haproxy.cfg.erb'
property :conf_cookbook, String, default: 'haproxy'
property :conf_file_mode, String, default: '0644'
property :hash_type, String, equal_to: %w(consistent map-based)

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init
  haproxy_config_resource.variables['listen'] ||= {}
  haproxy_config_resource.variables['listen'][new_resource.name] ||= {}
  haproxy_config_resource.variables['listen'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['bind'] ||= []
  if new_resource.bind.is_a? Hash
    new_resource.bind.map do |addresses, ports|
      (Array(addresses).product Array(ports)).each do |combo|
        haproxy_config_resource.variables['listen'][new_resource.name]['bind'] << combo.join(' ').strip
      end
    end
  else
    haproxy_config_resource.variables['listen'][new_resource.name]['bind'] << new_resource.bind
  end
  haproxy_config_resource.variables['listen'][new_resource.name]['maxconn'] ||= '' unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['stats'] ||= {} unless new_resource.stats.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['stats'].merge!(new_resource.stats) unless new_resource.stats.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['http_request'] = [new_resource.http_request].flatten unless new_resource.http_request.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['http_response'] ||= '' unless new_resource.http_response.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['http_response'] << new_resource.http_response unless new_resource.http_response.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['reqrep'] = [new_resource.reqrep].flatten unless new_resource.reqrep.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['reqirep'] = [new_resource.reqirep].flatten unless new_resource.reqirep.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['use_backend'] ||= [] unless new_resource.use_backend.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['use_backend'] << new_resource.use_backend unless new_resource.use_backend.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['default_backend'] ||= '' unless new_resource.default_backend.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['default_backend'] << new_resource.default_backend unless new_resource.default_backend.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['hash_type'] = new_resource.hash_type unless new_resource.hash_type.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['listen'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
