property :nameserver, Array
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

  haproxy_config_resource.variables['resolvers'] ||= {}
  haproxy_config_resource.variables['resolvers'][new_resource.name] ||= {}
  haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'] ||= [] unless new_resource.nameserver.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['nameserver'] << new_resource.nameserver unless new_resource.nameserver.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['resolvers'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
