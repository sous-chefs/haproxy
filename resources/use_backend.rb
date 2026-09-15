# frozen_string_literal: true

provides :haproxy_use_backend

use '_partial/_config_file'

property :use_backend, [String, Array],
          name_property: true,
          coerce: proc { |p| Array(p) },
          description: 'Switch to a specific backend if/unless an ACL-based condition is matched'

property :section, String,
          required: true,
          equal_to: %w(frontend listen),
          description: 'The frontend or listen section where the routing rule should be applied'

property :section_name, String,
          required: true,
          description: 'The name of the specific frontend or listen section'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables[new_resource.section] ||= {}

  haproxy_config_resource.variables[new_resource.section][new_resource.section_name] ||= {}

  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['use_backend'] ||= []
  haproxy_config_resource.variables[new_resource.section][new_resource.section_name]['use_backend'].push(new_resource.use_backend)
end

action :delete do
  haproxy_config_resource&.variables&.dig(new_resource.section, new_resource.section_name, 'use_backend')&.delete(new_resource.use_backend)
end
