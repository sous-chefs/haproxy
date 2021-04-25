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
  haproxy_config_resource.variables['userlist'][new_resource.name]['group'] << new_resource.group unless new_resource.group.nil?
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] ||= []
  haproxy_config_resource.variables['userlist'][new_resource.name]['user'] << new_resource.user unless new_resource.user.nil?
end
