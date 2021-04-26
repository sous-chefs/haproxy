property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :bind, [ String, Hash ]
property :state, [ String, nil ], equal_to: [ 'enabled', 'disabled', nil ]
property :server, Array
property :default_bind, String
property :default_server, String
property :table, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :conf_template_source, String, default: 'haproxy.cfg.erb'
property :conf_cookbook, String, default: 'haproxy'
property :conf_file_mode, String, default: '0644'

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
