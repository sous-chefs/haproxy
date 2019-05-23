property :bind, [ String, Hash ]
property :state, [ String, nil ], default: nil, equal_to: [ 'enabled', 'disabled', nil ]
property :server, Array
property :default_bind, String
property :default_server, String
property :table, Array
property :extra_options, Hash
property :config_dir, String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :config_cookbook, String, default: 'haproxy'

action :create do
  # As we're using the accumulator pattern we need to shove everything
  # into the root run context so each of the sections can find the parent
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
      source lazy { node.run_state['haproxy']['conf_template_source'][new_resource.config_file] ||= 'haproxy.cfg.erb' }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][new_resource.config_cookbook] ||= 'haproxy' }
      variables['peer'] ||= {}
      variables['peer'][new_resource.name] ||= {}
      variables['peer'][new_resource.name]['bind'] ||= {}
      variables['peer'][new_resource.name]['bind'] = new_resource.bind unless new_resource.bind.nil?
      variables['peer'][new_resource.name]['state'] = new_resource.state unless new_resource.state.nil?
      variables['peer'][new_resource.name]['server'] ||= []
      variables['peer'][new_resource.name]['server'] << new_resource.server unless new_resource.server.nil?
      variables['peer'][new_resource.name]['default_bind'] = new_resource.default_bind unless new_resource.default_bind.nil?
      variables['peer'][new_resource.name]['default_server'] = new_resource.default_server unless new_resource.default_server.nil?
      variables['peer'][new_resource.name]['table'] ||= []
      variables['peer'][new_resource.name]['table'] << new_resource.table unless new_resource.table.nil?
      variables['peer'][new_resource.name]['extra_options'] ||= {} unless new_resource.extra_options.nil?
      variables['peer'][new_resource.name]['extra_options'] = new_resource.extra_options unless new_resource.extra_options.nil?

      action :nothing
      delayed_action :create
    end
  end
end
