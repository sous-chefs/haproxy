use 'partial/_config_file'

property :group, Hash,
          description: 'Adds group <groupname> to the current userlist'

property :user, Hash,
          description: 'Adds user <username> to the current userlist'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['userlist'] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'].push(new_resource.group) if property_is_set?(:group)
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'].push(new_resource.user) if property_is_set?(:user)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['userlist'] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name] ||= {}
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'].delete(new_resource.group)
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'].delete(new_resource.user)
end
