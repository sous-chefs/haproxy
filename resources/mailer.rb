use 'partial/_config_file'

property :mailer, [String, Array],
          coerce: proc { |p| Array(p).flatten },
          description: 'Defines a mailer inside a mailers section'

property :timeout, String,
          description: 'Defines the time available for a mail/connection to be made and send to the mail-server'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['mailer'] ||= {}

  haproxy_config_resource.variables['mailer'][new_resource.name] ||= {}
  haproxy_config_resource.variables['mailer'][new_resource.name]['mailer'] = new_resource.mailer if property_is_set?(:mailer)
  haproxy_config_resource.variables['mailer'][new_resource.name]['timeout'] = new_resource.timeout if property_is_set?(:timeout)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['mailer'] ||= {}

  haproxy_config_resource.variables['mailer'][new_resource.name] ||= {}
  haproxy_config_resource.variables['mailer'].delete(new_resource.name) if haproxy_config_resource.variables['mailer'].key?(new_resource.name)
end
