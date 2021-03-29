property :acl, [String, Array], name_property: true
property :section, String, required: true, equal_to: %w(frontend listen backend)
property :section_name, String, required: true
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :conf_template_source, String, default: 'haproxy.cfg.erb'
property :conf_cookbook, String, default: 'haproxy'
property :conf_file_mode, String, default: '0644'
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables[new_resource.section] ||= {}
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'] ||= []
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'] += Array(new_resource.acl)
end
