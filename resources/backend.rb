property :name, String, name_property: true
property :server, Array
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    template config_file do
      source 'haproxy.cfg.erb'
      cookbook 'haproxy'
      variables['backend'] ||= {}
      variables['backend'][new_resource.name] ||= {}
      variables['backend'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
      variables['backend'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?

      action :nothing
      delayed_action :create
    end
  end
end
