property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, String, default: '/dev/log syslog info'
property :daemon, [TrueClass, FalseClass], default: true
property :debug_option, String, default: 'quiet', equal_to: %w(quiet debug)
property :stats_socket, String, default: lazy {"/var/run/haproxy.sock user #{haproxy_user} group #{haproxy_group}"}
property :stats_timeout, String, default: '2m'
property :maxconn, Integer, default: 4096
property :haproxy_retries, Integer, default: 3
property :client_timeout, String, default: '10s'
property :server_timeout, String, default: '10s'
property :connect_timeout, String, default: '10s'
property :config_cookbook, String, default: 'haproxy'
property :mode, String, default: 'http', equal_to: %w(http tcp)
property :chroot, String
property :log_tag, String, default: 'haproxy'
property :tuning, Hash, default: { "bufsize" => "262144" }
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, config_file) do |new_resource|
      cookbook 'haproxy'
      variables['user'] ||= ''
      variables['user'] << new_resource.haproxy_user
      variables['group'] ||= ''
      variables['group'] = new_resource.haproxy_group
      variables['pidfile'] ||= ''
      variables['pidfile'] << new_resource.pidfile
      variables['log'] ||= ''
      variables['log'] = new_resource.log
      variables['daemon'] ||= ''
      variables['daemon'] << new_resource.daemon.to_s
      variables['debug_option'] ||= ''
      variables['debug_option'] << new_resource.debug_option
      variables['stats_socket'] ||= ''
      variables['stats_socket'] << new_resource.stats_socket
      variables['stats_timeout'] ||= ''
      variables['stats_timeout'] << new_resource.stats_timeout
      variables['maxconn'] ||= new_resource.maxconn
      variables['retries'] ||= ''
      variables['retries'] << new_resource.haproxy_retries
      variables['client_timeout'] ||= ''
      variables['client_timeout'] << new_resource.client_timeout
      variables['server_timeout'] ||= ''
      variables['server_timeout'] << new_resource.server_timeout
      variables['connect_timeout'] ||= ''
      variables['connect_timeout'] << new_resource.connect_timeout
      variables['mode'] ||= '' unless new_resource.mode.nil?
      variables['mode'] << new_resource.mode unless new_resource.mode.nil?
      variables['chroot'] ||= '' unless new_resource.chroot.nil?
      variables['chroot'] << new_resource.chroot unless new_resource.chroot.nil?
      variables['log_tag'] ||= ''
      variables['log_tag'] << new_resource.log_tag
      variables['tuning'] ||= {} unless new_resource.tuning.nil?
      variables['tuning'] = new_resource.tuning unless new_resource.tuning.nil?
      variables['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?
      action :nothing
      delayed_action :create
    end
  end
end
