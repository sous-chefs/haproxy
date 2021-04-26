property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, [String, Array], default: '/dev/log syslog info'
property :daemon, [true, false], default: true
property :debug_option, String, default: 'quiet', equal_to: %w(quiet debug)
property :stats, Hash, default: lazy {
  {
    socket: "/var/run/haproxy.sock user #{haproxy_user} group #{haproxy_group}",
    timeout: '2m',
  }
}
property :maxconn, Integer, default: 4096
property :config_cookbook, String, default: 'haproxy'
property :chroot, String
property :log_tag, String, default: 'haproxy'
property :tuning, Hash
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

  haproxy_config_resource.variables['global'] ||= {}
  haproxy_config_resource.variables['global']['user'] ||= ''
  haproxy_config_resource.variables['global']['user'] << new_resource.haproxy_user
  haproxy_config_resource.variables['global']['group'] ||= ''
  haproxy_config_resource.variables['global']['group'] = new_resource.haproxy_group
  haproxy_config_resource.variables['global']['pidfile'] ||= ''
  haproxy_config_resource.variables['global']['pidfile'] << new_resource.pidfile
  haproxy_config_resource.variables['global']['log'] ||= []
  haproxy_config_resource.variables['global']['log'] << new_resource.log
  haproxy_config_resource.variables['global']['log_tag'] ||= ''
  haproxy_config_resource.variables['global']['log_tag'] << new_resource.log_tag
  haproxy_config_resource.variables['global']['chroot'] ||= '' unless new_resource.chroot.nil?
  haproxy_config_resource.variables['global']['chroot'] << new_resource.chroot unless new_resource.chroot.nil?
  haproxy_config_resource.variables['global']['daemon'] ||= ''
  haproxy_config_resource.variables['global']['daemon'] << new_resource.daemon.to_s
  haproxy_config_resource.variables['global']['debug_option'] ||= ''
  haproxy_config_resource.variables['global']['debug_option'] << new_resource.debug_option
  haproxy_config_resource.variables['global']['maxconn'] ||= '' unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['global']['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
  haproxy_config_resource.variables['global']['stats'] ||= {}
  haproxy_config_resource.variables['global']['stats'].merge!(new_resource.stats)
  haproxy_config_resource.variables['global']['tuning'] ||= {} unless new_resource.tuning.nil?
  haproxy_config_resource.variables['global']['tuning'] = new_resource.tuning unless new_resource.tuning.nil?
  haproxy_config_resource.variables['global']['extra_options'] ||= {} unless new_resource.extra_options.nil?
  haproxy_config_resource.variables['global']['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
end
