use 'partial/_config_file'

property :fastcgi, String,
          name_property: true,
          description: 'Name property - sets the fcgi-app name'

property :docroot, String,
          description: 'Define the document root on the remote host'

property :index, String,
          description: 'Define the script name that will be appended after an URI that ends with a slash'

property :log_stderr, String,
          description: 'Enable logging of STDERR messages reported by the FastCGI application'

property :option, Array,
          description: 'Array of HAProxy option directives'

property :extra_options, Hash,
          description: 'Used for setting any HAProxy directives'

unified_mode true

action_class do
  include Haproxy::Cookbook::ResourceHelpers
end

action :create do
  haproxy_config_resource_init

  haproxy_config_resource.variables['fastcgi'] ||= {}

  haproxy_config_resource.variables['fastcgi'][new_resource.name] ||= {}
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['docroot'] = new_resource.docroot if property_is_set?(:docroot)
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['index'] = new_resource.index if property_is_set?(:index)
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['log_stderr'] = new_resource.log_stderr if property_is_set?(:log_stderr)

  if property_is_set?(:option)
    haproxy_config_resource.variables['fastcgi'][new_resource.name]['option'] ||= []
    haproxy_config_resource.variables['fastcgi'][new_resource.name]['option'].push(new_resource.option)
  end

  haproxy_config_resource.variables['fastcgi'][new_resource.name]['extra_options'] = new_resource.extra_options if property_is_set?(:extra_options)
end

action :delete do
  haproxy_config_resource_init

  haproxy_config_resource.variables['fastcgi'] ||= {}

  haproxy_config_resource.variables['fastcgi'][new_resource.name] ||= {}
  haproxy_config_resource.variables['fastcgi'].delete(new_resource.name) if haproxy_config_resource.variables['fastcgi'].key?(new_resource.name)
end
