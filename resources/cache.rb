property :cache_name, String, name_property: true
property :total_max_size, Integer
property :max_object_size, Integer
property :max_age, Integer
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

  haproxy_config_resource.variables['cache'] ||= {}
  haproxy_config_resource.variables['cache'][new_resource.cache_name] ||= {}
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['total_max_size'] ||= new_resource.total_max_size
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['max_object_size'] ||= new_resource.max_object_size unless new_resource.max_object_size.nil?
  haproxy_config_resource.variables['cache'][new_resource.cache_name]['max_age'] ||= new_resource.max_age unless new_resource.max_age.nil?
end
