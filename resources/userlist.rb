property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :group, Hash
property :user, Hash
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

  haproxy_config_resource.variables['userlist'] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'] << new_resource.group unless new_resource.group.nil?
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] << new_resource.user unless new_resource.user.nil?
end
