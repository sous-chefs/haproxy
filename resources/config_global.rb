property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :pidfile, String, default: '/var/run/haproxy.pid'
property :log, Hash, default: { '/dev/log' => 'syslog info' }
# We need to find a way to nicely pass in syslog
property :daemon, [TrueClass, FalseClass], default: true
property :debug_option, String, default: 'quiet', equal_to: %w(quiet debug)
property :enable_stats_socket, [TrueClass, FalseClass], default: true
property :stats, String, default: 'socket /var/run/haproxy.sock user haproxy group haproxy'
property :maxconn, Integer, default: 4096

property :client_timeout, String, default: '10s'
property :server_timeout, String, default: '10s'
property :connect_timeout, String, default: '10s'
property :config_cookbook, String, default: 'haproxy'
property :enable_default_http, [TrueClass, FalseClass], default: true
property :mode, String, default: 'http', equal_to: %w(http)
property :ssl_mode, String, default: 'http'
property :bind_address, String, default: '0.0.0.0'
property :bind_port, Integer, default: 80

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    template config_file do
      source 'haproxy.cfg.erb'
      owner new_resource.haproxy_user
      group new_resource.haproxy_group
      mode '0644'
      cookbook 'haproxy'
      variables(
        user: new_resource.haproxy_user,
        group: new_resource.haproxy_group,
        pidfile: new_resource.pidfile,
        log: new_resource.log,
        deamon: new_resource.deamon,
        debug_option: new_resource.debug_option,
        enable_stats_socket: new_resource.enable_stats_socket,
        stats: new_resource.stats,
        maxconn: new_resource.maxconn,
        extra_options: new_resourcextra_options,

      )
      samba_services.each do |samba_service|
        notifies :restart, "service[#{samba_service}]"
      end

      action :nothing
      delayed_action :create
    end
end
