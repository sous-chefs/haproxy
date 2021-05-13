use 'partial/_config_file'

property :acl, [String, Array],
          name_property: true,
          coerce: proc { |p| Array(p) },
          description: 'The access control list items'

property :section, String,
          required: true,
          equal_to: %w(frontend listen backend),
          description: 'The section where the acl(s) should be applied'

property :section_name, String,
          required: true,
          description: 'The name of the specific frontend, listen or backend section'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables[new_resource.section] ||= {}

  haproxy_config_resource.variables[new_resource.section][new_resource.section_name] ||= {}

  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'] ||= []
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'].push(new_resource.acl)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables[new_resource.section] ||= {}
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'] ||= []
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['acl'].delete(new_resource.acl)
end
