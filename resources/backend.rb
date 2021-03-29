property :mode, String, equal_to: %w(http tcp health)
property :server, Array
property :tcp_request, Array
property :reqrep, [Array, String]
property :reqirep, [Array, String]
property :acl, Array
property :option, Array
property :extra_options, Hash
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
