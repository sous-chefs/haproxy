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
  haproxy_config_resource.variables['fastcgi'][new_resource.fastcgi] ||= {}
  haproxy_config_resource.variables['fastcgi'][new_resource.fastcgi]['docroot'] ||= new_resource.docroot unless new_resource.docroot.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.fastcgi]['index'] ||= new_resource.index unless new_resource.index.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.fastcgi]['log_stderr'] ||= new_resource.log_stderr unless new_resource.log_stderr.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['fastcgi'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
