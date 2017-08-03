property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, [String, Array], default: '/dev/log syslog info'
property :daemon, [TrueClass, FalseClass], default: true
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

action :create do
  node.default['haproxy']['user'] = new_resource.haproxy_user
  node.default['haproxy']['group'] = new_resource.haproxy_group
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['global'] ||= {}
      variables['global']['user'] ||= ''
      variables['global']['user'] << new_resource.haproxy_user
      variables['global']['group'] ||= ''
      variables['global']['group'] = new_resource.haproxy_group
      variables['global']['pidfile'] ||= ''
      variables['global']['pidfile'] << new_resource.pidfile
      variables['global']['log'] ||= []
      variables['global']['log'] << new_resource.log
      variables['global']['log_tag'] ||= ''
      variables['global']['log_tag'] << new_resource.log_tag
      variables['global']['chroot'] ||= '' unless new_resource.chroot.nil?
      variables['global']['chroot'] << new_resource.chroot unless new_resource.chroot.nil?
      variables['global']['daemon'] ||= ''
      variables['global']['daemon'] << new_resource.daemon.to_s
      variables['global']['debug_option'] ||= ''
      variables['global']['debug_option'] << new_resource.debug_option
      variables['global']['maxconn'] ||= '' unless new_resource.maxconn.nil?
      variables['global']['maxconn'] << new_resource.maxconn.to_s unless new_resource.maxconn.nil?
      variables['global']['stats'] ||= {}
      variables['global']['stats'].merge!(new_resource.stats)
      variables['global']['tuning'] ||= {} unless new_resource.tuning.nil?
      variables['global']['tuning'] = new_resource.tuning unless new_resource.tuning.nil?
      variables['global']['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['global']['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
