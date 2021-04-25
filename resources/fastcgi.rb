property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :fastcgi, String, name_property: true
property :docroot, String
property :index, String
property :log_stderr, String
property :option, Array
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
