property :mode, String, equal_to: %w(http tcp)
property :server, Array
property :tcp_request, Array
property :acl, Array
property :option, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] ||= 'haproxy' }
      variables['backend'] ||= {}
      variables['backend'][new_resource.name] ||= {}
      variables['backend'][new_resource.name]['mode'] ||= '' unless new_resource.mode.nil?
      variables['backend'][new_resource.name]['mode'] << new_resource.mode unless new_resource.mode.nil?
      variables['backend'][new_resource.name]['server'] ||= [] unless new_resource.server.nil?
      variables['backend'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
      variables['backend'][new_resource.name]['tcp_request'] ||= [] unless new_resource.tcp_request.nil?
      variables['backend'][new_resource.name]['tcp_request'] << new_resource.tcp_request unless new_resource.tcp_request.nil?
      variables['backend'][new_resource.name]['acl'] ||= [] unless new_resource.acl.nil?
      variables['backend'][new_resource.name]['acl'] << new_resource.acl unless new_resource.acl.nil?
      variables['backend'][new_resource.name]['option'] ||= [] unless new_resource.option.nil?
      variables['backend'][new_resource.name]['option'] << new_resource.option unless new_resource.option.nil?
      variables['backend'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['backend'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
